import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // On met un fond noir pour que la caméra ressorte bien
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          // LA CAMERA REELLE
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                debugPrint('Code trouvé : ${barcodes.first.rawValue}');
                // Ici tu pourras ajouter ta logique de validation
              }
            },
          ),
          
          // L'OVERLAY (Le dessin par dessus)
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250, // La taille du carré de visée
              ),
            ),
          ),
          
          const Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Text(
              "Scannez le reçu du client",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Un petit peintre personnalisé pour dessiner le cadre si tu n'as pas de librairie d'overlay
class QrScannerOverlayShape extends ShapeBorder {
  // ... (Je simplifie ici, utilise un simple Container avec bordure si besoin)
  final Color borderColor;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderRadius = 0,
    this.borderLength = 40,
    this.borderWidth = 10,
    this.cutOutSize = 250,
  });
  
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final height = rect.height;
    final boxRect = Rect.fromCenter(center: Offset(width/2, height/2), width: cutOutSize, height: cutOutSize);
    
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Dessine l'ombre autour du carré
    canvas.drawPath(
      Path.combine(PathOperation.difference, Path()..addRect(rect), Path()..addRRect(RRect.fromRectAndRadius(boxRect, Radius.circular(borderRadius)))),
      paint,
    );

    final linePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Dessine les coins
    canvas.drawRRect(RRect.fromRectAndRadius(boxRect, Radius.circular(borderRadius)), linePaint);
  }
  @override
  ShapeBorder scale(double t) => this;
}