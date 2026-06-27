using System.Reflection;

namespace Ticketa.Core.Helpers
{
  public static class Permissions
  {
    public static class Movies
    {
      public const string View = "movies:view";
      public const string Import = "movies:import";
      public const string Edit = "movies:edit";
      public const string Delete = "movies:delete";
    }

    public static class Showtimes
    {
      public const string View = "showtimes:view";
      public const string Create = "showtimes:create";
      public const string Edit = "showtimes:edit";
      public const string Delete = "showtimes:delete";
    }

    public static class Payments
    {
      public const string View = "payments:view";
      public const string Refund = "payments:refund";
    }

    public static class Bookings
    {
      public const string View = "bookings:view";
      public const string Scan = "bookings:scan";
    }

    public static class Users
    {
      public const string View = "users:view";
      public const string Create = "users:create";
      public const string Edit = "users:edit";
      public const string Delete = "users:delete";
    }

    public static class Roles
    {
      public const string View = "roles:view";
      public const string Create = "roles:create";
      public const string Edit = "roles:edit";
      public const string Delete = "roles:delete";
    }

    public static class Dashboard
    {
      public const string View = "dashboard:view";
    }

    public static IEnumerable<string> GetAll() =>
        typeof(Permissions)
            .GetNestedTypes(BindingFlags.Public)
            .SelectMany(t => t.GetFields(BindingFlags.Public | BindingFlags.Static))
            .Select(f => (string)f.GetValue(null)!);
  }
}
