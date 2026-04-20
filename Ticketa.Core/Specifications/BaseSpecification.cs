using System.Linq.Expressions;

namespace Ticketa.Core.Specifications
{
  public class BaseSpecification<T>
  {
    public Expression<Func<T, bool>>? Criteria { get; private set; }
    public Expression<Func<T, object>>? OrderBy { get; private set; }
    public Expression<Func<T, object>>? OrderByDesc { get; private set; }
    public int Take { get; private set; }
    public int Skip { get; private set; }
    public bool IsPagingEnabled { get; private set; }

    protected void AddCriteria(Expression<Func<T, bool>> criteria) => Criteria = criteria;

    protected void AddOrderBy(Expression<Func<T, object>> orderBy) => OrderBy = orderBy;

    protected void AddOrderByDesc(Expression<Func<T, object>> orderByDesc) => OrderByDesc = orderByDesc;

    protected void ApplyPaging(int skip, int take)
    {
      Skip = skip;
      Take = take;
      IsPagingEnabled = true;
    }
  }
}
