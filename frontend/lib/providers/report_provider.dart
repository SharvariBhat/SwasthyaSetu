import 'package:flutter/material.dart';
import '../services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  bool _isLoading = false;
  bool _isAnalyzing = false;
  String? _errorMessage;
  Map<String, dynamic>? _analysisResult;
  int _uploadProgress = 0;

  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get analysisResult => _analysisResult;
  int get uploadProgress => _uploadProgress;

  Future<bool> uploadAndAnalyzeReport({
    required String filePath,
    required String fileName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _uploadProgress = 0;
    notifyListeners();

    try {
      // Upload report
      final uploadResponse = await _reportService.uploadAndAnalyzeReport(
        filePath: filePath,
        fileName: fileName,
        onProgress: (sent, total) {
          _uploadProgress = ((sent / total) * 100).toInt();
          notifyListeners();
        },
      );

      final reportId = uploadResponse['reportId'];

      // Analyze report
      _isAnalyzing = true;
      notifyListeners();

      final analysisResponse = await _reportService.analyzeReport(
        reportId: reportId.toString(),
      );

      _analysisResult = analysisResponse['data'];
      _isLoading = false;
      _isAnalyzing = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isAnalyzing = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isAnalyzing = false;
    _errorMessage = null;
    _analysisResult = null;
    _uploadProgress = 0;
    notifyListeners();
  }
}
