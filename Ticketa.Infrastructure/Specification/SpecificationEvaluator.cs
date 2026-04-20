using Ticketa.Core.Specifications;

namespace Ticketa.Infrastructure.Specification
{
  public static class SpecificationEvaluator<T> where T : class
  {
    public static IQueryable<T> GetQuery(IQueryable<T> query, BaseSpecification<T> spec)
    {
      if (spec.Criteria is not null)
        query = query.Where(spec.Criteria);

      if (spec.OrderByDesc is not null)
        query = query.OrderByDescending(spec.OrderByDesc);
      else if (spec.OrderBy is not null)
        query = query.OrderBy(spec.OrderBy);

      if (spec.IsPagingEnabled)
        query = query.Skip(spec.Skip).Take(spec.Take);

      return query;
    }
  }
}
