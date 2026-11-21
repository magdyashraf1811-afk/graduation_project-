
import 'package:athaar_app/models/scan_apis/api_service.dart';
import 'package:athaar_app/models/scan_apis/artifact_model.dart';

class ArtifactRepository {
  final ApiService apiService;

  ArtifactRepository({required this.apiService});

  Future<List<ArtifactModel>> getArtifacts() async {
    final response = await apiService.getArtifacts();

    final List<dynamic> data = response.data;

    return data
        .map(
          (item) => ArtifactModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  Future<ArtifactModel> getArtifactById(String id) async {
    final response = await apiService.getArtifactById(id);

    return ArtifactModel.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  // AI Image Prediction
  Future<dynamic> predictArtifact(String imagePath) async {
    final response = await apiService.predictArtifact(imagePath);

    return response.data;
  }
}
