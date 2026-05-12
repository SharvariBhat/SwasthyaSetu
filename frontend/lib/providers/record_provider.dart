import 'package:flutter/material.dart';
import '../models/medical_record_model.dart';
import '../services/api_service.dart';
import '../config/constants/app_constants.dart';
import 'package:dio/dio.dart';

class RecordProvider extends ChangeNotifier {
  final List<MedicalRecordModel> _records = [];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<MedicalRecordModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.recordsEndpoint);
      if (response.statusCode == 200) {
        _records.clear();
        final List<dynamic> data = response.data['data'];
        _records.addAll(data.map((json) => MedicalRecordModel.fromJson(json)).toList());
      }
    } catch (e) {
      _error = 'Failed to fetch records';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(MedicalRecordModel record, {String? filePath}) async {
    try {
      Response response;
      if (filePath != null && filePath.isNotEmpty) {
        response = await _apiService.uploadFile(
          AppConstants.uploadReportEndpoint,
          filePath: filePath,
          additionalData: record.toJson(),
        );
      } else {
        response = await _apiService.post(
          AppConstants.uploadReportEndpoint,
          data: record.toJson(),
        );
      }
      if (response.statusCode == 201) {
        _records.insert(0, MedicalRecordModel.fromJson(response.data['data']));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to add record';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeRecord(int recordId) async {
    try {
      final response = await _apiService.delete('${AppConstants.recordsEndpoint}/$recordId');
      if (response.statusCode == 200) {
        _records.removeWhere((r) => r.recordId == recordId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to remove record';
      notifyListeners();
      rethrow;
    }
  }
}