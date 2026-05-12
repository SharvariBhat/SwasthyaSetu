import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale) {
    _localizedStrings = {};
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<bool> load() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/i18n/${locale.languageCode}.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings = jsonMap;
      return true;
    } catch (e) {
      print('Error loading localization: $e');
      _localizedStrings = {};
      return false;
    }
  }

  String translate(String key) {
    return _localizedStrings[key]?.toString() ?? key;
  }

  // App strings
  String get appName => translate('app_name');
  String get tagline => translate('tagline');
  
  // Auth strings
  String get emailLabel => translate('email_label');
  String get emailHint => translate('email_hint');
  String get passwordLabel => translate('password_label');
  String get passwordHint => translate('password_hint');
  String get loginButton => translate('login_button');
  String get registerLink => translate('register_link');
  String get dontHaveAccount => translate('dont_have_account');
  String get mobileNumberLabel => translate('mobile_number_label');
  String get sendOtpButton => translate('send_otp_button');
  String get verifyOtpTitle => translate('verify_otp_title');
  String get verifyOtpDescription => translate('verify_otp_description');
  String get resendOtp => translate('resend_otp');
  String get verifyButton => translate('verify_button');
  String get or => translate('or');
  
  // Common strings
  String get welcome => translate('welcome');
  String get logout => translate('logout');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get language => translate('language');
  String get notifications => translate('notifications');
  String get help => translate('help');
  String get about => translate('about');
  String get error => translate('error');
  String get success => translate('success');
  String get loading => translate('loading');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get back => translate('back');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'ta', 'te', 'kn', 'ml'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
