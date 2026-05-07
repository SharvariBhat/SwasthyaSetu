import 'package:flutter/material.dart';

import '../models/medical_record_model.dart';

class RecordProvider extends ChangeNotifier {

  final List<MedicalRecordModel>
      _records = [];

  bool _isLoading = false;

  String? _error;

  List<MedicalRecordModel> get records =>
      _records;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  Future<void> fetchRecords() async {

    _isLoading = true;

    notifyListeners();

    try {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      _records.clear();

      _records.addAll([

        MedicalRecordModel(

          recordId: 1,

          recordType: 'LAB_REPORT',

          fileUrl: 'report.pdf',

          diagnosis: 'Normal Blood Test',

          doctorName: 'Dr. Sharma',
        ),
      ]);

      _error = null;

    } catch (e) {

      _error =
          'Failed to fetch records';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> addRecord(
      MedicalRecordModel record) async {

    _records.add(record);

    notifyListeners();
  }

  Future<void> removeRecord(
      int recordId) async {

    _records.removeWhere(

      (record) =>
          record.recordId ==
          recordId,
    );

    notifyListeners();
  }
}