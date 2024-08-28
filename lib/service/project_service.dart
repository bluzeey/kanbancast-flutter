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

  Future<int> upvoteTask(int taskId) async {
    try {
      final response = await _dio.get('tasks/upvote/$taskId');
      if (response.statusCode == 200) {
        final data = response.data;
        final votes = data['votes'] as int;
        print("Vote incremented successfully");
        return votes;
      } else {
        print("Failed to increment votes: ${response.statusCode}");
        throw Exception('Failed to increment votes');
      }
    } catch (error) {
      print("Error incrementing votes: $error");
      throw Exception('Error incrementing votes');
    }
  }

  Future<int> upvoteComment(int commentId) async {
    try {
      final response = await _dio.get('comments/upvote/$commentId');
      if (response.statusCode == 200) {
        final data = response.data;
        final votes = data['votes'] as int;
        print("Comment vote incremented successfully");
        return votes;
      } else {
        print("Failed to increment comment votes: ${response.statusCode}");
        throw Exception('Failed to increment comment votes');
      }
    } catch (error) {
      print("Error incrementing comment votes: $error");
      throw Exception('Error incrementing comment votes');
    }
  }

  Future<Map<String, dynamic>> submitNewComment(
      int taskId, String content) async {
    try {
      final response = await _dio.get('tasks/comment/create', queryParameters: {
        'taskId': taskId,
        'content': content,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['comment'] as Map<String, dynamic>;
        print("Comment submitted successfully");
        return data;
      } else {
        print("Failed to submit comment: ${response.statusCode}");
        throw Exception('Failed to submit comment');
      }
    } catch (error) {
      print("Error submitting comment: $error");
      throw Exception('Error submitting comment');
    }
  }

  Future<Map<String, dynamic>> submitNewTask(
      String title, String description) async {
    try {
      final response = await _dio.get('tasks/create', queryParameters: {
        'title': title,
        'description': description,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['task'] as Map<String, dynamic>;
        print("Task submitted successfully");
        return data;
      } else {
        print("Failed to submit task: ${response.statusCode}");
        throw Exception('Failed to submit task');
      }
    } catch (error) {
      print("Error submitting task: $error");
      throw Exception('Error submitting task');
    }
  }
}
