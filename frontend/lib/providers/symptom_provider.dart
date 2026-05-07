import 'package:flutter/material.dart';

import '../models/symptom_model.dart';

class SymptomProvider extends ChangeNotifier {

  final List<SymptomModel>
      _symptoms = [];

  bool _isLoading = false;

  String? _error;

  List<SymptomModel> get symptoms =>
      _symptoms;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  Future<void> fetchSymptoms() async {

    _isLoading = true;

    notifyListeners();

    try {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      _symptoms.clear();

      _symptoms.addAll([

        SymptomModel(

          logId: 1,

          symptom: 'Headache',

          severity: 'LOW',
        ),

        SymptomModel(

          logId: 2,

          symptom: 'Fever',

          severity: 'HIGH',
        ),
      ]);

      _error = null;

    } catch (e) {

      _error =
          'Failed to fetch symptoms';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> addSymptom(
      SymptomModel symptom) async {

    _symptoms.add(symptom);

    notifyListeners();
  }

  Future<void> removeSymptom(
      int logId) async {

    _symptoms.removeWhere(

      (symptom) =>
          symptom.logId == logId,
    );

    notifyListeners();
  }
}