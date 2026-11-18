enum ScanResultType { image, qr }

class ScanResult {
  final ScanResultType type;
  final String value; // مسار الصورة، أو النص اللي جوا الـ QR

  const ScanResult.image(this.value) : type = ScanResultType.image;
  const ScanResult.qr(this.value) : type = ScanResultType.qr;
}