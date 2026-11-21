
class ArtifactModel {
  final String artifactId;
  final String className;
  final Map<String, ArtifactLanguageContent> content;

  const ArtifactModel({
    required this.artifactId,
    required this.className,
    required this.content,
  });

  factory ArtifactModel.fromJson(Map<String, dynamic> json) {
    final contentJson =
        json['content'] as Map<String, dynamic>? ?? {};

    return ArtifactModel(
      artifactId: json['artifact_id'] ?? '',
      className: json['class_name'] ?? '',
      content: contentJson.map(
            (key, value) => MapEntry(
          key,
          ArtifactLanguageContent.fromJson(
            Map<String, dynamic>.from(value),
          ),
        ),
      ),
    );
  }

  ArtifactLanguageContent? getContent(String languageCode) {
    return content[languageCode] ?? content['en'];
  }
}

class ArtifactLanguageContent {
  final String name;
  final String text;
  final String audioUrl;

  const ArtifactLanguageContent({
    required this.name,
    required this.text,
    required this.audioUrl,
  });

  factory ArtifactLanguageContent.fromJson(
      Map<String, dynamic> json,
      ) {
    return ArtifactLanguageContent(
      name: json['name'] ?? '',
      text: json['text'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }
}
