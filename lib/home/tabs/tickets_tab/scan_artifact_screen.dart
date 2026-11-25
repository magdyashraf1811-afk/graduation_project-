import 'dart:async';
import 'package:athaar_app/models/scan_apis/api_service.dart';
import 'package:athaar_app/models/scan_apis/prediction_model.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum ScanMode {
  camera,
  qr,
  gallery,
}

class ScanArtifactScreen extends StatefulWidget {
  const ScanArtifactScreen({super.key});

  @override
  State<ScanArtifactScreen> createState() =>
      _ScanArtifactScreenState();
}

class _ScanArtifactScreenState extends State<ScanArtifactScreen> {
  static const Color gold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF15191C);

  CameraController? _cameraController;

  final ApiService _apiService = ApiService();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final MobileScannerController _qrController =
  MobileScannerController();

  bool _isCameraInitialized = false;
  bool _isLoading = false;
  bool _isQrMode = false;
  bool _isProcessingQr = false;
  bool _isSwitchingCamera = false;

  ScanMode _selectedMode = ScanMode.camera;

  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No camera found on this device.');
      }

      final backCamera = cameras.firstWhere(
            (camera) =>
        camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isCameraInitialized = true;
        _cameraError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;

      setState(() {
        _cameraError = e.description ?? e.code;
        _isCameraInitialized = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cameraError = e.toString();
        _isCameraInitialized = false;
      });
    }
  }

  Future<void> _captureImage() async {
    final controller = _cameraController;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isLoading ||
        _isSwitchingCamera) {
      return;
    }

    try {
      final XFile image = await controller.takePicture();
      await _predictArtifact(image.path);
    } catch (e) {
      _showMessage('Could not capture image.');
    }
  }

  Future<void> _pickImage() async {
    if (_isLoading || _isSwitchingCamera) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) return;

      await _predictArtifact(image.path);
    } catch (e) {
      _showMessage('Could not select image.');
    }
  }

  Future<void> _predictArtifact(String imagePath) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
      await _apiService.predictArtifact(imagePath);

      if (response.data is! Map) {
        throw Exception('Invalid server response.');
      }

      final prediction = PredictionModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );

      if (!mounted) return;

      if (prediction.recognized) {
        _showPredictionResult(prediction);
      } else {
        _showMessage('Artifact was not recognized.');
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;

      final message = responseData is Map
          ? responseData['message']?.toString()
          : null;

      _showMessage(
        message ?? e.message ?? 'Server connection failed.',
      );
    } catch (e) {
      _showMessage('Something went wrong: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPredictionResult(PredictionModel prediction) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _PredictionResultSheet(
          prediction: prediction,
          audioPlayer: _audioPlayer,
        );
      },
    ).whenComplete(() {
      _audioPlayer.stop();
    });
  }

  Future<void> _toggleQrMode() async {
    if (_isLoading || _isSwitchingCamera) return;

    setState(() {
      _isSwitchingCamera = true;
    });

    try {
      if (!_isQrMode) {
        // Release the camera before opening the QR scanner.
        final controller = _cameraController;
        _cameraController = null;

        if (mounted) {
          setState(() {
            _isCameraInitialized = false;
            _isQrMode = true;
            _isProcessingQr = false;
            _selectedMode = ScanMode.qr;
          });
        }

        await controller?.dispose();
      } else {
        await _qrController.stop();

        if (!mounted) return;

        setState(() {
          _isQrMode = false;
          _isProcessingQr = false;
          _selectedMode = ScanMode.camera;
        });

        await _initializeCamera();
      }
    } catch (e) {
      _showMessage('Could not switch camera mode.');
    } finally {
      if (mounted) {
        setState(() {
          _isSwitchingCamera = false;
        });
      }
    }
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (_isProcessingQr) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value != null && value.isNotEmpty) {
        _isProcessingQr = true;

        _showMessage('QR Code detected: $value');

        setState(() {
          _isQrMode = false;
          _selectedMode = ScanMode.camera;
        });

        _initializeCamera();
        break;
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF292F33),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _qrController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? darkBackground
        : const Color(0xFFF5F2EA);

    final primaryText =
    isDark ? Colors.white : const Color(0xFF242424);

    final secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(primaryText),
            const SizedBox(height: 14),

            Text(
              _isQrMode
                  ? 'Scan the museum QR code'
                  : 'Point your camera at an Egyptian artifact',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCameraArea(),

                      if (!_isQrMode)
                        const _CameraFrame(),

                      if (_isLoading || _isSwitchingCamera)
                        Container(
                          color: Colors.black.withValues(
                            alpha: 0.55,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  color: gold,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Please wait...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildControls(secondaryText),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 12,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 21,
            ),
          ),

          const Spacer(),

          Text(
            'Scan Artifact',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          const Icon(
            Icons.auto_awesome,
            color: gold,
            size: 26,
          ),

          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    if (_isQrMode) {
      return MobileScanner(
        controller: _qrController,
        onDetect: _onQrDetected,
      );
    }

    if (!_isCameraInitialized ||
        _cameraController == null) {
      return Container(
        color: const Color(0xFF202629),
        child: Center(
          child: _cameraError != null
              ? Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: gold,
                  size: 45,
                ),
                const SizedBox(height: 12),

                Text(
                  _cameraError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _initializeCamera,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          )
              : const CircularProgressIndicator(
            color: gold,
          ),
        ),
      );
    }

    final controller = _cameraController!;
    final previewSize = controller.value.previewSize!;

    return Container(
      color: Colors.black,
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  Future<void> _selectGallery() async {
    if (_isLoading || _isSwitchingCamera) return;

    setState(() {
      _selectedMode = ScanMode.gallery;
    });

    await _pickImage();

    if (mounted) {
      setState(() {
        _selectedMode = _isQrMode ? ScanMode.qr : ScanMode.camera;
      });
    }
  }

  Widget _buildControls(Color secondaryText) {
    final bool isCameraSelected =
        _selectedMode == ScanMode.camera;

    final Color cameraColor =
    isCameraSelected ? gold : secondaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ControlButton(
            icon: Icons.qr_code_scanner_rounded,
            label: 'QR Scan',
            color: _selectedMode == ScanMode.qr
                ? gold
                : secondaryText,
            onTap: _isLoading || _isSwitchingCamera
                ? null
                : _toggleQrMode,
          ),

          GestureDetector(
            onTap: _isLoading ||
                _isQrMode ||
                _isSwitchingCamera
                ? null
                : _captureImage,
            child: Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cameraColor,
                  width: 2.5,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isCameraSelected
                      ? gold
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: isCameraSelected
                      ? Colors.black
                      : secondaryText,
                  size: 30,
                ),
              ),
            ),
          ),

          _ControlButton(
            icon: Icons.photo_library_outlined,
            label: 'Gallery',
            color: _selectedMode == ScanMode.gallery
                ? gold
                : secondaryText,
            onTap: _isLoading || _isSwitchingCamera
                ? null
                : _selectGallery,
          ),
        ],
      ),
    );
  }

}

class _CameraFrame extends StatelessWidget {
  const _CameraFrame();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: const [
            Expanded(
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CornerFrame(topLeft: true),
                  _CornerFrame(topRight: true),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _CornerFrame(bottomLeft: true),
                  _CornerFrame(bottomRight: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerFrame extends StatelessWidget {
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  const _CornerFrame({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: CustomPaint(
        painter: _CornerPainter(
          color: const Color(0xFFD4AF37),
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerPainter({
    required this.color,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (topLeft) {
      path
        ..moveTo(0, size.height)
        ..lineTo(0, 0)
        ..lineTo(size.width, 0);
    } else if (topRight) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else if (bottomRight) {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) {
    return false;
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 27,
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionResultSheet extends StatefulWidget {
  final PredictionModel prediction;
  final AudioPlayer audioPlayer;

  const _PredictionResultSheet({
    required this.prediction,
    required this.audioPlayer,
  });

  @override
  State<_PredictionResultSheet> createState() =>
      _PredictionResultSheetState();
}

class _PredictionResultSheetState
    extends State<_PredictionResultSheet> {
  static const Color gold = Color(0xFFD4AF37);

  bool _isAudioLoading = false;

  Future<void> _toggleAudio() async {
    final player = widget.audioPlayer;
    final audioUrl = widget.prediction.audioUrl;

    if (audioUrl.isEmpty) {
      _showMessage('Audio guide is not available.');
      return;
    }

    try {
      if (player.playing) {
        await player.pause();
        return;
      }

      setState(() {
        _isAudioLoading = true;
      });

      if (player.processingState == ProcessingState.idle) {
        await player.setUrl(audioUrl);
      }

      unawaited(player.play());
    } catch (e) {
      _showMessage('Could not play audio guide.');
    } finally {
      if (mounted) {
        setState(() {
          _isAudioLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final prediction = widget.prediction;
    final player = widget.audioPlayer;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 25,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Artifact Recognized',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                prediction.name,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                prediction.description.isEmpty
                    ? 'No description available.'
                    : prediction.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.8),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: gold,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Recognition Confidence'),
                    ),
                    Text(
                      '${(prediction.confidence * 100).toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Audio Guide',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  StreamBuilder<bool>(
                    stream: player.playingStream,
                    initialData: player.playing,
                    builder: (context, snapshot) {
                      final isPlaying =
                          snapshot.data ?? false;

                      return IconButton(
                        onPressed: _isAudioLoading
                            ? null
                            : _toggleAudio,
                        icon: _isAudioLoading
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: gold,
                          ),
                        )
                            : Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: gold,
                          size: 42,
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: StreamBuilder<Duration>(
                      stream: player.positionStream,
                      builder: (context, snapshot) {
                        final position =
                            snapshot.data ?? Duration.zero;

                        final duration =
                            player.duration ?? Duration.zero;

                        final double maxValue =
                        duration.inMilliseconds > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1.0;

                        final double currentValue = position
                            .inMilliseconds
                            .toDouble()
                            .clamp(0.0, maxValue)
                            .toDouble();

                        return Column(
                          children: [
                            Slider(
                              value: currentValue,
                              min: 0.0,
                              max: maxValue,
                              activeColor: gold,
                              onChanged:
                              duration.inMilliseconds == 0
                                  ? null
                                  : (value) {
                                player.seek(
                                  Duration(
                                    milliseconds:
                                    value.toInt(),
                                  ),
                                );
                              },
                            ),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: gold,
                    side: const BorderSide(color: gold),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}