using System;
using Ticketa.Core.Entities;

namespace Ticketa.Core.Interfaces;

public interface IHallRepository : IRepository<Hall>
{
    public void UpdateAsync(Hall hall);
}
