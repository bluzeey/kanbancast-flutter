import 'package:dio/dio.dart';

class ProjectService {
  final String apiKey;
  final Dio _dio;

  ProjectService({required this.apiKey})
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://kanbancast.com/api/',
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': apiKey,
            },
          ),
        );

  Future<List<dynamic>> fetchStatuses() async {
    try {
      final response = await _dio.get('projects');
      if (response.statusCode == 200) {
        final data = response.data;
        final statuses = data['project']['statuses'] as List<dynamic>;
        print("Statuses fetched successfully");
        return statuses;
      } else {
        print("Failed to fetch statuses: ${response.statusCode}");
        throw Exception('Failed to fetch statuses');
      }
    } catch (error) {
      print("Error fetching statuses: $error");
      throw Exception('Error fetching statuses');
    }
  }
}
