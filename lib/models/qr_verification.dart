class QrVerification {
  final bool success;
  final String message;
  final String? scannedUrl;

  QrVerification({
    required this.success,
    required this.message,
    this.scannedUrl,
  });

  factory QrVerification.fromUrl(String url) {
    // Définir le pattern de l'URL Wave
    final RegExp waveUrlPattern = RegExp(
        r'^https:\/\/qr\.wave\.com\/[A-Za-z0-9_-]+\/[A-Za-z0-9]+\/[A-Za-z0-9_-]+$');

    // Vérifier si l'URL correspond au pattern
    final bool isValidFormat = waveUrlPattern.hasMatch(url);

    return QrVerification(
      success: isValidFormat,
      message: isValidFormat ? 'Valid Wave QR Code' : 'Invalid QR Code Format',
      scannedUrl: url,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'scannedUrl': scannedUrl,
    };
  }
}
