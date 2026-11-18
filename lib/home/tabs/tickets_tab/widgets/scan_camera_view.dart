import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:athaar_app/utils/app_colors.dart';

class ScanCameraView extends StatelessWidget {
  final CameraController? camera;
  final MobileScannerController? qrController;
  final bool qrMode;
  final String? error;
  final ValueChanged<BarcodeCapture> onQrDetected;

  const ScanCameraView({
    super.key,
    required this.camera,
    required this.qrController,
    required this.qrMode,
    required this.error,
    required this.onQrDetected,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Container(
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: AppColors.goldColor, size: 48),
            const SizedBox(height: 12),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (qrMode) {
      final qr = qrController;
      if (qr == null) return const _Loading();
      return MobileScanner(controller: qr, onDetect: onQrDetected);
    }

    final cam = camera;
    if (cam == null || !cam.value.isInitialized) return const _Loading();


    final size = cam.value.previewSize!;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.height,
        height: size.width,
        child: CameraPreview(cam),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.goldColor),
    );
  }
}