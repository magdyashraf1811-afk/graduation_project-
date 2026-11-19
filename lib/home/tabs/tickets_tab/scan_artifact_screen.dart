import 'dart:io';

import 'package:camera/camera.dart';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:athaar_app/utils/app_colors.dart';
import 'models/scan_result.dart';
import 'widgets/capture_button.dart';
import 'widgets/qr_brackets_painter.dart';
import 'widgets/scan_action_button.dart';
import 'widgets/scan_camera_view.dart';

class ScanArtifactScreen extends StatefulWidget {
  final bool showBack;

  const ScanArtifactScreen({super.key, this.showBack = true});

  @override
  State<ScanArtifactScreen> createState() => _ScanArtifactScreenState();
}

class _ScanArtifactScreenState extends State<ScanArtifactScreen>
    with WidgetsBindingObserver {
  CameraController? _camera;
  MobileScannerController? _qr;
  bool _flashOn = false;
  bool _qrMode = false;
  bool _initializing = false;
  bool _handled = false; // عشان النتيجة ما تتعالجش مرتين
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    _qr?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      if (_qrMode) {
        _qr?.stop().catchError((_) {});
      } else {
        final old = _camera;
        if (old == null) return;
        setState(() => _camera = null);
        old.dispose();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_qrMode) {
        _qr?.start().catchError((_) {});
      } else {
        _initCamera();
      }
    }
  }

  // ---------------- camera ----------------

  Future<void> _initCamera() async {
    if (_initializing || _qrMode || _camera != null) return;
    _initializing = true;
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller =
      CameraController(back, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted || _qrMode) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _error = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.code == 'CameraAccessDenied'
            ? 'Camera permission is required.\nPlease allow it from the phone settings.'
            : 'Could not open the camera.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No camera available on this device.');
    } finally {
      _initializing = false;
    }
  }

  Future<void> _toggleFlash() async {
    final turnOn = !_flashOn;
    try {
      if (_qrMode) {
        await _qr?.toggleTorch();
      } else {
        await _camera?.setFlashMode(turnOn ? FlashMode.torch : FlashMode.off);
      }
      if (mounted) setState(() => _flashOn = turnOn);
    } catch (_) {
      // الجهاز ممكن ميكونش في فلاش
    }
  }

  Future<void> _setQrMode(bool enable) async {
    if (enable == _qrMode) return;
    if (enable) {
      final oldCamera = _camera;
      setState(() {
        _camera = null;
        _qrMode = true;
        _flashOn = false;
        _error = null;
      });
      await WidgetsBinding.instance.endOfFrame;
      await oldCamera?.dispose();
      if (!mounted) return;
      setState(() => _qr = MobileScannerController());
    } else {
      final oldQr = _qr;
      setState(() {
        _qr = null;
        _qrMode = false;
        _flashOn = false;
      });
      await WidgetsBinding.instance.endOfFrame;
      await oldQr?.dispose();
      await _initCamera();
    }
  }

  // ---------------- الأفعال ----------------

  Future<void> _capture() async {
    if (_qrMode) {

      await _setQrMode(false);
      return;
    }
    final cam = _camera;
    if (cam == null || !cam.value.isInitialized || cam.value.isTakingPicture) {
      return;
    }
    try {
      final file = await cam.takePicture();
      await _onResult(ScanResult.image(file.path));
    } on CameraException {
    }
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) await _onResult(ScanResult.image(picked.path));
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue;
    if (value == null || value.isEmpty) return;
    _onResult(ScanResult.qr(value));
  }

  Future<void> _onResult(ScanResult result) async {
    if (_handled || !mounted) return;
    _handled = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.fieldBgColor,
        title: const Text(
          'Scan result (temporary)',
          style: TextStyle(color: AppColors.goldColor, fontSize: 16),
        ),
        content: result.type == ScanResultType.image
            ? Image.file(File(result.value), height: 220, fit: BoxFit.cover)
            : Text(result.value, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    _handled = false;
  }

  // ---------------- الشكل ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              const Text(
                'Point your camera at the artifact or scan the QR code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildCameraArea()),
              const SizedBox(height: 24),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        widget.showBack
            ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.goldColor, size: 20),
        )
            : const SizedBox(width: 48),
        const Expanded(
          child: Text(
            'Scan Artifact',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.goldColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: _toggleFlash,
          icon: Icon(
            _flashOn ? Icons.flash_on : Icons.flash_off,
            color: AppColors.goldColor,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraArea() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.goldBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ScanCameraView(
              camera: _camera,
              qrController: _qr,
              qrMode: _qrMode,
              error: _error,
              onQrDetected: _onQrDetected,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: CustomPaint(painter: QrBracketsPainter()),
            ),
            Positioned(
              top: 24,
              right: 24,
              child: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: AppColors.goldColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScanActionButton(
          icon: _qrMode ? Icons.photo_camera_outlined : Icons.qr_code_scanner,
          label: _qrMode ? 'Camera' : 'Scan QR Code',
          onTap: () => _setQrMode(!_qrMode),
        ),
        CaptureButton(onTap: _capture),
        ScanActionButton(
          icon: Icons.photo_outlined,
          label: 'Gallery',
          onTap: _pickFromGallery,
        ),
      ],
    );
  }
}