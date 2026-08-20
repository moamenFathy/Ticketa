using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Polly;
using Ticketa.Core.Entities;
using Ticketa.Core.Helpers;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Interfaces.IServices;
using Ticketa.Core.Interfaces.Services;
using Ticketa.Core.Mapping;
using Ticketa.Core.Settings;
using Ticketa.Infrastructure.Authorization;
using Ticketa.Infrastructure.BackgroundServices;
using Ticketa.Infrastructure.Data;
using Ticketa.Infrastructure.ExternalService;
using Ticketa.Infrastructure.Repositories;
using Ticketa.Infrastructure.Service;

namespace Ticketa.Infrastructure.Extensions
{
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
      services.AddIdentity<AppUser, AppRole>(opt =>
      {
        opt.User.RequireUniqueEmail = true;
        opt.SignIn.RequireConfirmedEmail = true;
      })
      .AddEntityFrameworkStores<ApplicationDbContext>()
      .AddDefaultTokenProviders();

      // Core services
      services.AddSingleton<TimeConversions>();
      services.AddScoped<IUnitOfWork, UnitOfWork>();
      services.Scan(scan => scan
        .FromAssemblyOf<MoviesService>()
        .AddClasses(c => c.Where(t => t.Name.EndsWith("Service")
          && t.Name != "ShowtimeCompletionService"
          && t.Name != "TmdbService"
          && t.Name != "VercelAnalyticsService"))
        .AsImplementedInterfaces()
        .WithScopedLifetime()
      );

      // Email
      services.Configure<EmailSettings>(configuration.GetSection("EmailSettings"));
      services.AddScoped(sp => sp.GetRequiredService<IOptions<EmailSettings>>().Value);

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

      // Vercel Web Analytics
      services.Configure<VercelAnalyticsOptions>(configuration.GetSection("Vercel"));
      services.AddHttpClient<IVercelAnalyticsService, VercelAnalyticsService>(opt =>
      {
        opt.BaseAddress = new Uri("https://api.vercel.com/");
        opt.Timeout = TimeSpan.FromSeconds(10);
      });

      // Background services
      services.AddHostedService<ShowtimeCompletionService>();

      return services;
    }

    public static IServiceCollection AddTicketaAuthorization(
        this IServiceCollection services)
    {
      services.AddAuthorization(options =>
      {
        foreach (var permission in Permissions.GetAll())
          options.AddPolicy(permission, policy =>
              policy.Requirements.Add(new PermissionRequirement(permission)));
      });

      services.AddSingleton<IAuthorizationHandler, PermissionAuthorizationHandler>();

      return services;
    }
  }
}
