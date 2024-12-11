/*
void _handleScannedData(Barcode data) {
  controller?.pauseCamera();

  // Vérification du format QR
  final verification = QrVerification.fromUrl(data.code ?? '');

  if (!verification.success) {
    _showErrorDialog('Invalid QR Code Format');
    return;
  }

  // Simulation d'une requête serveur
  _verifyTicketWithServer(verification.scannedUrl!);
}

Future<void> _verifyTicketWithServer(String qrUrl) async {
  try {
    // Simuler un appel API
    // À remplacer par votre véritable appel API
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT'),
      body: {'qrCode': qrUrl},
    );

    if (response.statusCode == 200) {
      final scanResponse = ScanResponse.fromJson(
        jsonDecode(response.body),
      );

      _showResultDialog(scanResponse);
    } else {
      _showErrorDialog('Server Error');
    }
  } catch (e) {
    _showErrorDialog('Network Error');
  }
}

void _showResultDialog(ScanResponse response) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(response.success ? 'Ticket Valid' : 'Ticket Invalid'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${response.success ? 'Valid ✅' : 'Invalid ❌'}'),
            SizedBox(height: 8),
            Text('Message: ${response.message}'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.confirmation_number,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tickets scannés: ${response.ticketCount}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller?.resumeCamera();
              setState(() {
                isScanned = false;
              });
            },
            child: Text('Scanner suivant'),
          ),
        ],
      );
    },
  );
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller?.resumeCamera();
              setState(() {
                isScanned = false;
              });
            },
            child: Text('Réessayer'),
          ),
        ],
      );
    },
  );
}*/
