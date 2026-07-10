namespace Ticketa.Core.Interfaces.IServices
{
  public interface IQrCodeService
  {
    byte[] GeneratePng(string content, int pixelsPerModule = 10);
  }
}
