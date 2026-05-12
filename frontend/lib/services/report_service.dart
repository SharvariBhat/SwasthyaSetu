import '../models/medical_record_model.dart';
import 'api_service.dart';

class ReportService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> uploadAndAnalyzeReport({
    required String filePath,
    required String fileName,
    required Function(int, int) onProgress,
  }) async {
    try {
      // Use standard medical record upload for now
      // Note: We might need to pass record data if the backend requires it
      final response = await _apiService.uploadFile(
        '/medical-records/upload',
        filePath: filePath,
        additionalData: {
          'record_type': 'LAB_REPORT',
          'record_date': DateTime.now().toIso8601String(),
          'diagnosis': 'AI Analysis Pending',
          'doctor_name': 'AI Assistant',
        },
      );

      if (response.statusCode == 201) {
        final recordData = response.data['data'];
        return {
          'reportId': recordData['id']?.toString() ?? recordData['record_id']?.toString(),
          ...response.data
        };
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
      final response = await _apiService.post(
        '/medical-records/$reportId/analyze',
        data: {},
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
}

