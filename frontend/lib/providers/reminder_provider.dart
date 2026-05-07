import 'package:flutter/material.dart';

import '../models/reminder_model.dart';

class ReminderProvider extends ChangeNotifier {

  final List<ReminderModel> _reminders = [];

  bool _isLoading = false;

  String? _error;

  List<ReminderModel> get reminders =>
      _reminders;

  bool get isLoading =>
      _isLoading;

  String? get error =>
      _error;

  Future<void> fetchReminders() async {

    _isLoading = true;

    notifyListeners();

    try {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      _reminders.clear();

      _reminders.addAll([

        ReminderModel(

          reminderId: 1,

          type: 'MEDICINE',

          reminderTime: '08:00 AM',

          status: 'ACTIVE',
        ),

        ReminderModel(

          reminderId: 2,

          type: 'CHECKUP',

          reminderTime: '02:00 PM',

          status: 'ACTIVE',
        ),
      ]);

      _error = null;

    } catch (e) {

      _error =
          'Failed to fetch reminders';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> addReminder(
      ReminderModel reminder) async {

    _reminders.add(reminder);

    notifyListeners();
  }

  Future<void> removeReminder(
      int reminderId) async {

    _reminders.removeWhere(

      (reminder) =>
          reminder.reminderId ==
          reminderId,
    );

    notifyListeners();
  }
}