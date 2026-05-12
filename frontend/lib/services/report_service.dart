import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants/app_constants.dart';

class ReportService {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5000';

  Future<Map<String, dynamic>> uploadAndAnalyzeReport({
    required String filePath,
    required String fileName,
    required Function(int, int) onProgress,
  }) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '$_baseUrl/api/reports/upload',
        data: formData,
        onSendProgress: (int sent, int total) {
          onProgress(sent, total);
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to upload report: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error uploading report: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeReport({
    required String reportId,
  }) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final response = await _dio.post(
        '$_baseUrl/api/reports/analyze',
        data: {'reportId': reportId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to analyze report: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error analyzing report: $e');
    }
  }

  /// Get token from SharedPreferences
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.tokenKey);
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }
}
