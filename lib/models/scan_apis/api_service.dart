
import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );
  }

  Future<Response> checkHealth() async {
    return await dio.get(ApiConstants.health);
  }

  Future<Response> getArtifacts() async {
    return await dio.get(ApiConstants.artifacts);
  }

  Future<Response> getArtifactById(String id) async {
    return await dio.get(ApiConstants.artifactById(id));
  }

  // Send image to AI prediction endpoint
  Future<Response> predictArtifact(String imagePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath),
    });

    return await dio.post(
      ApiConstants.predict,
      data: formData,
    );
  }
}
