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
      var url = $"{BaseUrl}/movie/popular?language=en-US&page=1";
      var response = await _httpClient.GetFromJsonAsync<TmdbPopularResponseDto>(url);
      return response?.Results ?? [];
    }
  }
}
