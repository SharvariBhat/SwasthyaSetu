import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../services/api_service.dart';
import '../config/constants/app_constants.dart';

class MedicineProvider extends ChangeNotifier {
  final List<MedicineModel> _medicines = [];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<MedicineModel> get medicines => _medicines;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMedicines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.medicinesEndpoint);
      if (response.statusCode == 200) {
        _medicines.clear();
        final List<dynamic> data = response.data['data'];
        _medicines.addAll(data.map((json) => MedicineModel.fromJson(json)).toList());
      }
    } catch (e) {
      _error = 'Failed to fetch medicines';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    try {
      final response = await _apiService.post(
        AppConstants.medicinesEndpoint,
        data: medicine.toJson(),
      );
      if (response.statusCode == 201) {
        _medicines.insert(0, MedicineModel.fromJson(response.data['data']));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to add medicine';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeMedicine(int memberMedicineId) async {
    try {
      final response = await _apiService.delete('${AppConstants.medicinesEndpoint}/$memberMedicineId');
      if (response.statusCode == 200) {
        _medicines.removeWhere((m) => m.memberMedicineId == memberMedicineId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to remove medicine';
      notifyListeners();
      rethrow;
    }
  }
}