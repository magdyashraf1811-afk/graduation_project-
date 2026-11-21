
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';

import 'package:athaar_app/models/scan_apis/api_service.dart';
import 'package:athaar_app/models/scan_apis/prediction_model.dart';

class PredictionTestScreen extends StatefulWidget {
  final bool showBack;

  const PredictionTestScreen({
    super.key,
    this.showBack = true,
  });

  @override
  State<PredictionTestScreen> createState() =>
      _PredictionTestScreenState();
}

class _PredictionTestScreenState extends State<PredictionTestScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  File? _selectedImage;
  PredictionModel? _prediction;

  bool _isLoading = false;
  bool _isAudioLoading = false;

  String? _errorMessage;
  String? _audioError;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    await _audioPlayer.stop();

    setState(() {
      _selectedImage = File(image.path);
      _prediction = null;
      _errorMessage = null;
      _audioError = null;
    });
  }

  Future<void> _predictImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
      _prediction = null;
      _errorMessage = null;
      _audioError = null;
    });

    await _audioPlayer.stop();

    try {
      final response = await _apiService.predictArtifact(
        _selectedImage!.path,
      );

      final prediction = PredictionModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );

      if (!mounted) return;

      setState(() {
        _prediction = prediction;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            e.response?.data?.toString() ??
                e.message ??
                'Server connection failed';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleAudio() async {
    final audioUrl = _prediction?.audioUrl ?? '';

    if (audioUrl.isEmpty) {
      setState(() {
        _audioError = 'Audio URL is not available.';
      });
      return;
    }

    try {
      setState(() {
        _isAudioLoading = true;
        _audioError = null;
      });

      if (_audioPlayer.playerState.processingState ==
          ProcessingState.completed) {
        await _audioPlayer.seek(Duration.zero);
      }

      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        if (_audioPlayer.audioSource == null) {
          await _audioPlayer.setUrl(audioUrl);
        }

        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _audioError = 'Could not play audio: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAudioLoading = false;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF252B30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF63).withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audio Guide',
            style: TextStyle(
              color: Color(0xFFD4AF63),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          StreamBuilder<PlayerState>(
            stream: _audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;

              return Row(
                children: [
                  IconButton(
                    onPressed: _isAudioLoading
                        ? null
                        : _toggleAudio,
                    iconSize: 42,
                    color: const Color(0xFFD4AF63),
                    icon: _isAudioLoading
                        ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF63),
                        strokeWidth: 2,
                      ),
                    )
                        : Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'Listen to artifact description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, positionSnapshot) {
              final position =
                  positionSnapshot.data ?? Duration.zero;

              return StreamBuilder<Duration?>(
                stream: _audioPlayer.durationStream,
                builder: (context, durationSnapshot) {
                  final duration =
                      durationSnapshot.data ?? Duration.zero;

                  final maxValue = duration.inMilliseconds
                      .toDouble();

                  final currentValue = position.inMilliseconds
                      .toDouble()
                      .clamp(0.0, maxValue > 0 ? maxValue : 1.0);

                  return Column(
                    children: [
                      Slider(
                        value: currentValue,
                        max: maxValue > 0 ? maxValue : 1.0,
                        activeColor: const Color(0xFFD4AF63),
                        inactiveColor: Colors.white24,
                        onChanged: maxValue > 0
                            ? (value) {
                          _audioPlayer.seek(
                            Duration(
                              milliseconds: value.round(),
                            ),
                          );
                        }
                            : null,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),

          if (_audioError != null) ...[
            const SizedBox(height: 8),
            Text(
              _audioError!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15191C),

      appBar: AppBar(
        automaticallyImplyLeading: widget.showBack,
        title: const Text('Artifact Recognition Test'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF252B30),
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: _selectedImage == null
                  ? const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.white54,
                  size: 70,
                ),
              )
                  : Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _pickImage,
              child: const Text('Choose Image'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _selectedImage == null || _isLoading
                  ? null
                  : _predictImage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Predict Artifact'),
            ),

            const SizedBox(height: 25),

            if (_errorMessage != null)
              _buildResultCard(
                title: 'Error',
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),

            if (_prediction != null) ...[
              if (_prediction!.recognized) ...[
                _buildResultCard(
                  title: 'Recognized Artifact',
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        _prediction!.name,
                        style: const TextStyle(
                          color: Color(0xFFD4AF63),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _prediction!.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.7,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Confidence: ${(_prediction!.confidence * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(
                          color: Color(0xFFD4AF63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Artifact ID: ${_prediction!.artifactId}',
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _buildAudioPlayer(),
              ] else
                _buildResultCard(
                  title: 'Not Recognized',
                  child: const Text(
                    'The artifact could not be recognized. Try another image.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF252B30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF63).withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4AF63),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
