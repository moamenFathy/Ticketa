using QRCoder;
using Ticketa.Core.Interfaces.IServices;

namespace Ticketa.Infrastructure.Service
{
  public class QrCodeService : IQrCodeService
  {
    public byte[] GeneratePng(string content, int pixelsPerModule = 10)
    {
      using var generator = new QRCodeGenerator();
      using var data = generator.CreateQrCode(content, QRCodeGenerator.ECCLevel.Q);
      using var qrCode = new PngByteQRCode(data);
      return qrCode.GetGraphic(pixelsPerModule);
    }
  }
}
