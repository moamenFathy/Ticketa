using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Polly;
using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Core.Mapping;
using Ticketa.Core.Settings;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.ExternalService;
using Ticketa.Infrastructure.Repositories;
using Ticketa.Infrastructure.Service;

namespace Ticketa.Infrastructure.Extensions
{
  // Ticketa.Infrastructure/Extensions/ServiceCollectionExtensions.cs
  public static class ServiceCollectionExtensions
  {
    public static IServiceCollection AddTicketaInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
      // Database
      services.AddDbContext<ApplicationDbContext>(opt =>
          opt.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

      // Identity
      services.AddIdentity<AppUser, IdentityRole>(opt =>
      {
        opt.User.RequireUniqueEmail = true;
        opt.SignIn.RequireConfirmedEmail = true;
      })
      .AddEntityFrameworkStores<ApplicationDbContext>()
      .AddDefaultTokenProviders();

      // Core services
      services.AddScoped<IUnitOfWork, UnitOfWork>();
      services.AddScoped<IMoviesService, MoviesService>();
      services.AddScoped<IShowtimeService, ShowtimeService>();
      services.AddScoped<IAuthService, AuthService>();

      // Email
      services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));
      services.AddScoped(sp => sp.GetRequiredService<IOptions<EmailSettings>>().Value);
      services.AddScoped<IEmailService, EmailService>();

      // AutoMapper
      services.AddAutoMapper(cfg =>
          cfg.AddMaps(typeof(MovieProfile).Assembly));

      // TMDB HTTP client
      services.AddHttpClient<ITmdbService, TmdbService>(opt =>
      {
        opt.BaseAddress = new Uri("https://api.themoviedb.org/3/");
        opt.Timeout = TimeSpan.FromSeconds(10);
      })
      .AddTransientHttpErrorPolicy(policy =>
          policy.WaitAndRetryAsync(3, retryAttempt =>
              TimeSpan.FromSeconds(Math.Pow(2, retryAttempt))));

      return services;
    }
  }
}
