import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';

import 'models/qr_verification.dart';
import 'models/scan_response.dart';

import 'package:http/http.dart' as http;

class ScanningUI extends StatefulWidget {
  @override
  _ScanningUIState createState() => _ScanningUIState();
}

class _ScanningUIState extends State<ScanningUI> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  bool isScanned = false;

  String uuid = Uuid().v4();

  void _generateNewUuid() {
    setState(() {
      uuid = Uuid().v4(); // Generate a new random UUID
      print('uuid -----:' +uuid);
    });
  }


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
      backgroundColor: const Color(0xFFCAC4D0),
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
    print('Status: ${verification.success ? 'Valid ✅' : 'Invalid ❌'}');
    print('Message: ${verification.message}');

/*    if(verification.success) {
    //  _sendToServer(data.code ?? '');
    }
    else{
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
                    _generateNewUuid();
                    Navigator.of(context).pop();
                    // Ajoutez ici la logique pour traiter un code QR valide
                  },
                  child: Text('Process Valid QR'),
                ),
            ],
          );
        },
      );
    }*/

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFE7F9F1),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(height: 8),
              Text(
                'Ticket Valide !',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow(
                  'Date d\'achat de ticket',
                  '15/05/2024',
                  Icons.calendar_today,
                ),
                Divider(color: Colors.white30),
                _buildInfoRow(
                  'Ticket No',
                  '0000334404',
                  Icons.confirmation_number,
                ),
                Divider(color: Colors.white30),
                _buildInfoRow(
                  'Section',
                  'Zone A',
                  Icons.location_on,
                ),
                Divider(color: Colors.white30),
                _buildInfoRow(
                  'Utilisateur',
                  'Moussa Diop',
                  Icons.person,
                ),
                Divider(color: Colors.white30),
                _buildInfoRow(
                  'Ticket restaurant',
                  'OUI',
                  Icons.restaurant,
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  _generateNewUuid();
                  Navigator.of(context).pop();
                  controller?.resumeCamera();
                  setState(() {
                    isScanned = false;
                  });
                },
                child: Text(
                  'Scanner suivant',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        /*  title: Text(verification.success ? 'Valid QR Code' : 'Invalid QR Code'),
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
                  _generateNewUuid();
                  Navigator.of(context).pop();
                  // Ajoutez ici la logique pour traiter un code QR valide
                },
                child: Text('Process Valid QR'),
              ),
          ],*/
        );
      },
    );
  }

/*  void _showResultDialog(ScanResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(response.success ? 'Ticket Valid' : 'Ticket Invalid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('UUID: ${response.uuid}'),
              SizedBox(height: 8),
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
                // Copier l'UUID dans le presse-papiers
                Clipboard.setData(ClipboardData(text: response.uuid));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('UUID copié dans le presse-papiers')),
                );
              },
              child: Text('Copier UUID'),
            ),
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

  Future<void> _sendToServer(String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'qrCode': qrCode,
          // Ajoutez d'autres données si nécessaire
        }),
      );

      if (response.statusCode == 200) {
        // Conversion de la réponse en objet ScanResponse
        final scanResponse = ScanResponse.fromJson(
          jsonDecode(response.body),
        );

        // Affichage du dialogue avec les informations du serveur
        _showResultDialog(scanResponse);
      } else {
        // Gestion des erreurs serveur
        _showErrorDialog('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs réseau
      _showErrorDialog('Erreur réseau: $e');
    }
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

Widget _buildInfoRow(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

