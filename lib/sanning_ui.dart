import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'models/qr_verification.dart';

class ScanningUI extends StatefulWidget {
  @override
  _ScanningUIState createState() => _ScanningUIState();
}

class _ScanningUIState extends State<ScanningUI> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool isScanned = false;

  @override
  void reassemble() {
    super.reassemble();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCAC4D0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: result != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Type: ${result!.format.name}'),
                          Text('Data: ${result!.code}'),
                        ],
                      )
                    : Text('Scan a QR code'),
              ),
            ),

            Expanded(
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  ScanningUI(),),

                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'End scanning',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ),
            ),)
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null && !isScanned) {
          isScanned = true;
          _handleScannedData(result!);
        }
      });
    });
  }


  void _handleScannedData(Barcode data) {
    controller?.pauseCamera();

    // Création de l'objet de vérification
    final verification = QrVerification.fromUrl(data.code ?? '');

    // Log du résultat en JSON
    print('Résultat de la vérification: ${jsonEncode(verification.toJson())}');

    // Ajout des prints pour le debug
    print('Format du code scanné: ${data.format}');
    print('Contenu du code scanné: ${data.code}');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(verification.success ? 'Valid QR Code' : 'Invalid QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Format: ${data.format}'),
              SizedBox(height: 8),
              Text('Content: ${data.code}'),
              SizedBox(height: 8),
              Text('Status: ${verification.success ? 'Valid ✅' : 'Invalid ❌'}'),
              SizedBox(height: 8),
              Text('Message: ${verification.message}'),
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
              child: Text('Scan Again'),
            ),
            if (verification.success)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Ajoutez ici la logique pour traiter un code QR valide
                },
                child: Text('Process Valid QR'),
              ),
          ],
        );
      },
    );
  }


/*
  void _handleScannedData(Barcode data) {
    controller?.pauseCamera();

    // Ajout des prints pour le debug
    print('Format du code scanné: ${data.format}');
    print('Contenu du code scanné: ${data.code}');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Format: ${data.format.name}'),

              SizedBox(height: 8),
              Text('Content: ${data.code}'),
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
              child: Text('Scan Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Process Data'),
            ),
          ],
        );
      },
    );
  }
*/
}
