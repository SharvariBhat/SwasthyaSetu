import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;

  LanguageProvider() {
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedLanguage = _prefs.getString('language_code') ?? 'en';
      _locale = Locale(savedLanguage);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error initializing preferences: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    try {
      await _prefs.setString('language_code', languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
    notifyListeners();
  }

  List<Map<String, String>> get supportedLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिन्दी'},
    {'code': 'ta', 'name': 'தமிழ்'},
    {'code': 'te', 'name': 'తెలుగు'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ'},
    {'code': 'ml', 'name': 'മലയാളം'},
  ];
}
