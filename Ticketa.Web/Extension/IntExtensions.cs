namespace Ticketa.Web.Extension
{
  public static class IntExtensions
  {
    public static string ToRuntimeString(this int minutes)
    {
      var h = minutes / 60;
      var m = minutes % 60;
      return h > 0 ? $"{h}h {m}m" : $"{m}m";
    }
  }
}
