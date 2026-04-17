using Microsoft.Extensions.Configuration;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Ticketa.Core.DTOs;
using Ticketa.Core.Interfaces.Services;

namespace Ticketa.Infrastructure.Service
{
  public class TmdbService : ITmdbService
  {
    private readonly HttpClient _httpClient;
    private const string BaseUrl = "https://api.themoviedb.org/3";

    public TmdbService(HttpClient httpClient, IConfiguration configuration)
    {
      _httpClient = httpClient;
      var apiKey = configuration["Tmdb:ApiKey"]
                  ?? throw new InvalidOperationException("TMDB API key not configured.");

      // Set the TMDB Read Access Token (v4) as a Bearer token
      _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
    }

    public async Task<IReadOnlyList<TmdbMovieDto>> GetPopularMoviesAsync()
    {
      var url = $"{BaseUrl}/movie/now_playing?language=en-US&page=1";
      var response = await _httpClient.GetFromJsonAsync<TmdbPopularResponseDto>(url);
      return response?.Results ?? [];
    }

    public async Task<TmdbMovieDto?> GetMovieByIdAsync(int tmdbId)
    {
      var url = $"{BaseUrl}/movie/{tmdbId}?language=en-US";
      return await _httpClient.GetFromJsonAsync<TmdbMovieDto>(url);
    }

    public async Task<string?> GetTrailerKeyAsync(int tmdbId)
    {
      var url = $"{BaseUrl}/movie/{tmdbId}/videos?language=en-US";
      var response = await _httpClient.GetFromJsonAsync<TmdbVideoResponseDto>(url);
      // Look for an official trailer on YouTube
      return response?.Results
          .Where(v => v.Site == "YouTube" && v.Type == "Trailer" && v.Official).Select(v => v.Key).FirstOrDefault()

          ?? response?.Results
          .Where(v => v.Site == "YouTube" && v.Type == "Trailer").Select(v => v.Key).FirstOrDefault();
    }

    public async Task<TmdbMovieDetailDto> GetMovieDetailAsync(int tmdbId)
    {
      var url = $"{BaseUrl}/movie/{tmdbId}?language=en-US";
      return await _httpClient.GetFromJsonAsync<TmdbMovieDetailDto>(url);
    }

    public async Task<IReadOnlyList<TmdbMovieDto>> SearchMoviesAsync(string query)
    {
      if (string.IsNullOrWhiteSpace(query))
        return [];

      var encoded = Uri.EscapeDataString(query);

      var language = IsArabic(query) ? "ar" : "en-US";
      var url = $"{BaseUrl}/search/movie?language={language}&query={encoded}&page=1";

      var response = await _httpClient.GetFromJsonAsync<TmdbPopularResponseDto>(url);
      var results = response?.Results ?? [];

      if (!results.Any() && IsArabic(query))
      {
        var fallbackUrl = $"{BaseUrl}/search/movie?language=en-US&query={encoded}&page=1";
        var fallbackResponse = await _httpClient.GetFromJsonAsync<TmdbPopularResponseDto>(fallbackUrl);
        results = fallbackResponse?.Results ?? [];
      }

      return results;
    }

    private bool IsArabic(string text)
    {
      return text.Any(c => c >= 0x0600 && c <= 0x06FF);
    }
  }
}
