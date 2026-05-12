import 'package:flutter/material.dart';
import '../models/symptom_model.dart';
import '../services/api_service.dart';
import '../config/constants/app_constants.dart';

class SymptomProvider extends ChangeNotifier {
  final List<SymptomModel> _symptoms = [];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<SymptomModel> get symptoms => _symptoms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSymptoms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.symptomsEndpoint);
      if (response.statusCode == 200) {
        _symptoms.clear();
        final List<dynamic> data = response.data['data'];
        _symptoms.addAll(data.map((json) => SymptomModel.fromJson(json)).toList());
      }
    } catch (e) {
      _error = 'Failed to fetch symptoms';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSymptom(SymptomModel symptom) async {
    try {
      final response = await _apiService.post(
        AppConstants.symptomsEndpoint,
        data: symptom.toJson(),
      );
      if (response.statusCode == 201) {
        _symptoms.insert(0, SymptomModel.fromJson(response.data['data']));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to add symptom';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeSymptom(int logId) async {
    try {
      final response = await _apiService.delete('${AppConstants.symptomsEndpoint}/$logId');
      if (response.statusCode == 200) {
        _symptoms.removeWhere((s) => s.logId == logId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to remove symptom';
      notifyListeners();
      rethrow;
    }
  }
}