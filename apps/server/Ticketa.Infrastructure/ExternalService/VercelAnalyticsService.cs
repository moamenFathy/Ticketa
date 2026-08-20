using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Ticketa.Core.DTOs.Analytics;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Settings;

namespace Ticketa.Infrastructure.ExternalService
{
  public class VercelAnalyticsService : IVercelAnalyticsService
  {
    private readonly HttpClient _httpClient;
    private readonly ILogger<VercelAnalyticsService> _logger;
    private readonly VercelAnalyticsOptions _options;

    public VercelAnalyticsService(
        HttpClient httpClient,
        IOptions<VercelAnalyticsOptions> options,
        ILogger<VercelAnalyticsService> logger)
    {
      _httpClient = httpClient;
      _options = options.Value;
      _logger = logger;

      if (string.IsNullOrWhiteSpace(_options.Token) || string.IsNullOrWhiteSpace(_options.ProjectId))
        throw new InvalidOperationException("Vercel analytics token/project not configured.");

      _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", _options.Token);
    }

    public async Task<SiteAnalyticsSummaryDto> GetSummaryAsync(
        DateOnly since, DateOnly until, CancellationToken ct = default)
    {
      var countTask = QueryCountAsync(since, until, ct);
      var countryTask = QueryAggregateAsync("country", since, until, 10, ct);
      var deviceTask = QueryAggregateAsync("deviceType", since, until, 10, ct);
      var osTask = QueryAggregateAsync("osName", since, until, 10, ct);
      var browserTask = QueryAggregateAsync("browserName", since, until, 10, ct);

      await Task.WhenAll(countTask, countryTask, deviceTask, osTask, browserTask);

      var (visitors, pageviews) = countTask.Result;

      return new SiteAnalyticsSummaryDto
      {
        Visitors = visitors,
        PageViews = pageviews,
        ByCountry = countryTask.Result,
        ByDevice = deviceTask.Result,
        ByOs = osTask.Result,
        ByBrowser = browserTask.Result
      };
    }

    private async Task<(int Visitors, int PageViews)> QueryCountAsync(
        DateOnly since, DateOnly until, CancellationToken ct)
    {
      try
      {
        var url = BuildUrl("v1/query/web-analytics/visits/count", since, until);
        var response = await _httpClient.GetFromJsonAsync<VercelCountResponseDto>(url, ct);
        return (response?.Data?.Visitors ?? 0, response?.Data?.PageViews ?? 0);
      }
      catch (Exception ex)
      {
        _logger.LogError(ex, "Error fetching Vercel analytics count");
        return (0, 0);
      }
    }

    private async Task<List<AnalyticsBreakdownItemDto>> QueryAggregateAsync(
        string by, DateOnly since, DateOnly until, int limit, CancellationToken ct)
    {
      try
      {
        var url = BuildUrl($"v1/query/web-analytics/visits/aggregate?by={Uri.EscapeDataString(by)}&limit={limit}", since, until);
        var response = await _httpClient.GetFromJsonAsync<VercelAggregateResponseDto>(url, ct);

        return response?.Data?
            .Where(r => r.Extra.TryGetValue(by, out var value) && value.ValueKind == JsonValueKind.String)
            .Select(r => new AnalyticsBreakdownItemDto
            {
              Label = r.Extra[by].GetString() ?? "Unknown",
              Visitors = r.Visitors,
              PageViews = r.PageViews
            })
            .ToList() ?? [];
      }
      catch (Exception ex)
      {
        _logger.LogError(ex, "Error fetching Vercel analytics aggregate by {By}", by);
        return [];
      }
    }

    private string BuildUrl(string path, DateOnly since, DateOnly until)
    {
      var query = new List<KeyValuePair<string, string>>
      {
        new("since", since.ToString("yyyy-MM-dd")),
        new("until", until.ToString("yyyy-MM-dd"))
      };

      if (!string.IsNullOrWhiteSpace(_options.TeamId))
        query.Add(new KeyValuePair<string, string>("teamId", _options.TeamId!));
      query.Add(new KeyValuePair<string, string>("projectId", _options.ProjectId));

      var qs = string.Join("&", query.Select(kv => $"{Uri.EscapeDataString(kv.Key)}={Uri.EscapeDataString(kv.Value)}"));
      var separator = path.Contains('?') ? "&" : "?";
      return $"{path}{separator}{qs}";
    }
  }

  public class VercelCountResponseDto
  {
    [JsonPropertyName("data")]
    public VercelCountDataDto? Data { get; set; }
  }

  public class VercelCountDataDto
  {
    [JsonPropertyName("visitors")]
    public int Visitors { get; set; }

    [JsonPropertyName("pageviews")]
    public int PageViews { get; set; }
  }

  public class VercelAggregateResponseDto
  {
    [JsonPropertyName("data")]
    public List<VercelAggregateRowDto>? Data { get; set; }
  }

  public class VercelAggregateRowDto
  {
    [JsonPropertyName("visitors")]
    public int Visitors { get; set; }

    [JsonPropertyName("pageviews")]
    public int PageViews { get; set; }

    [JsonExtensionData]
    public Dictionary<string, JsonElement> Extra { get; set; } = [];
  }
}