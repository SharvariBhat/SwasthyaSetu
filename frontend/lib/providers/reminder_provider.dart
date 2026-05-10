import 'package:flutter/material.dart';
import '../models/reminder_model.dart';
import '../services/api_service.dart';
import '../config/constants/app_constants.dart';

class ReminderProvider extends ChangeNotifier {
  final List<ReminderModel> _reminders = [];
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchReminders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(AppConstants.remindersEndpoint);
      if (response.statusCode == 200) {
        _reminders.clear();
        final List<dynamic> data = response.data['data'];
        _reminders.addAll(data.map((json) => ReminderModel.fromJson(json)).toList());
      }
    } catch (e) {
      _error = 'Failed to fetch reminders';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReminder(ReminderModel reminder) async {
    try {
      final response = await _apiService.post(
        AppConstants.remindersEndpoint,
        data: reminder.toJson(),
      );
      if (response.statusCode == 201) {
        _reminders.insert(0, ReminderModel.fromJson(response.data['data']));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to add reminder';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeReminder(int reminderId) async {
    try {
      final response = await _apiService.delete('${AppConstants.remindersEndpoint}/$reminderId');
      if (response.statusCode == 200) {
        _reminders.removeWhere((r) => r.reminderId == reminderId);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to remove reminder';
      notifyListeners();
      rethrow;
    }
  }
}