using Ticketa.Core.Entities;
using Ticketa.Core.Interfaces.IRepositories;
using Ticketa.Infrastructure.Data;

namespace Ticketa.Infrastructure.Repositories;

public class HallRepository : GenericRepository<Hall>, IHallRepository
{
  public HallRepository(ApplicationDbContext context) : base(context)
  {
  }

  public void Update(Hall hall)
  {
    var existingHall = _context.Halls.Find(hall.Id)
        ?? throw new KeyNotFoundException($"Hall with ID {hall.Id} not found");

    // Only Name is editable — HallType is immutable after creation
    existingHall.Name = hall.Name;

    _context.Halls.Update(existingHall);
  }
}
