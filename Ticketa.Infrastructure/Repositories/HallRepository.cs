using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories;

public class HallRepository : Repository<Hall>, IHallRepository
{
    public HallRepository(ApplicationDbContext context) : base(context)
    {
    }

    public async void UpdateAsync(Hall hall)
    {
        var existingHall = await _context.Halls.FindAsync(hall.Id) ?? throw new KeyNotFoundException($"Hall with ID {hall.Id} not found");

        existingHall.Name = hall.Name;
        existingHall.TotalSeats = hall.TotalSeats;

        _context.Halls.Update(existingHall);
    }
}
