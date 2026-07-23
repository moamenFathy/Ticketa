using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Ticketa.Core.Enums;
using Ticketa.Core.Interfaces;
using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.BackgroundServices
{
  public class ShowtimeCompletionService : BackgroundService
  {
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<ShowtimeCompletionService> _logger;
    private readonly TimeSpan _checkInterval = TimeSpan.FromMinutes(5);

    public ShowtimeCompletionService(IServiceScopeFactory scopeFactory, ILogger<ShowtimeCompletionService> logger)
    {
      _scopeFactory = scopeFactory;
      _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
      _logger.LogInformation("ShowtimeCompletionService started");

      while (!stoppingToken.IsCancellationRequested)
      {
        try
        {
          await CompleteExpiredShowtimesAsync(stoppingToken);
        }
        catch (Exception ex)
        {
          _logger.LogError(ex, "Error completing expired showtimes");
        }

        await Task.Delay(_checkInterval, stoppingToken);
      }
    }

    private async Task CompleteExpiredShowtimesAsync(CancellationToken ct)
    {
      using var scope = _scopeFactory.CreateScope();
      var uow = scope.ServiceProvider.GetRequiredService<IUnitOfWork>();

      var spec = new ShowtimeCompletionSpecification();
      var expiredShowtimes = await uow.Showtimes.GetAllWithSpecAsync(spec, ct);

      if (expiredShowtimes.Count == 0)
        return;

      foreach (var showtime in expiredShowtimes)
      {
        showtime.Status = ShowtimeStatus.Completed;
        showtime.IsArchived = true;
        showtime.ArchivedAt = DateTime.UtcNow;
      }

      await uow.SaveAsync();

      _logger.LogInformation("Completed {Count} expired showtime(s)", expiredShowtimes.Count);
    }
  }
}
