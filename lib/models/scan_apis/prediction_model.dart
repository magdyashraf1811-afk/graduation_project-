
import 'package:athaar_app/models/scan_apis/api_constants.dart';

class PredictionModel {
  final String artifactId;
  final String className;
  final double confidence;
  final bool recognized;
  final String language;
  final Map<String, dynamic> content;

  const PredictionModel({
    required this.artifactId,
    required this.className,
    required this.confidence,
    required this.recognized,
    required this.language,
    required this.content,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      artifactId: json['artifact_id']?.toString() ?? '',
      className: json['class_name']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      recognized: json['recognized'] == true,
      language: json['language']?.toString() ?? 'en',
      content: Map<String, dynamic>.from(
        json['localized_content'] ??
            (json['content'] as Map?)?[json['language'] ?? 'en'] ??
            {},
      ),
    );
  }

  String get name => content['name']?.toString() ?? className;

  String get description => content['text']?.toString() ?? '';

  String get audioUrl {
    final path = content['audio_url']?.toString() ?? '';

    if (path.isEmpty) return '';

    return Uri.parse(ApiConstants.baseUrl)
        .resolve(path)
        .toString();
  }
}
