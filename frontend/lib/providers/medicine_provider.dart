import 'package:flutter/material.dart';

import '../models/medicine_model.dart';

class MedicineProvider extends ChangeNotifier {

  final List<MedicineModel> _medicines = [];

  bool _isLoading = false;

  String? _error;

  List<MedicineModel> get medicines =>
      _medicines;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  Future<void> fetchMedicines() async {

    _isLoading = true;

    notifyListeners();

    try {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      _medicines.clear();

      _medicines.addAll([

        MedicineModel(

          memberMedicineId: 1,

          medicineId: 1,

          medicineName: 'Paracetamol',

          dosage: '1 Tablet',

          timing: 'Morning',

          frequency: 'Daily',
        ),

        MedicineModel(

          memberMedicineId: 2,

          medicineId: 2,

          medicineName: 'Vitamin D',

          dosage: '2 Tablets',

          timing: 'Night',

          frequency: 'Weekly',
        ),
      ]);

      _error = null;

    } catch (e) {

      _error =
          'Failed to fetch medicines';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> addMedicine(
      MedicineModel medicine) async {

    _medicines.add(medicine);

    notifyListeners();
  }

  Future<void> removeMedicine(
      int memberMedicineId) async {

    _medicines.removeWhere(

      (medicine) =>
          medicine.memberMedicineId ==
          memberMedicineId,
    );

    notifyListeners();
  }
}