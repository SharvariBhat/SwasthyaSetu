class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:5000/api';
  static const String apiVersion = '/v1';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String getUserEndpoint = '/users';
  static const String uploadReportEndpoint = '/medical-records/upload';
  static const String recordsEndpoint = '/medical-records';
  static const String medicinesEndpoint = '/medicines';
  static const String symptomsEndpoint = '/symptoms';
  static const String remindersEndpoint = '/reminders';

  // Validation
  static const int phoneNumberLength = 10;
  static const int aadhaarLength = 12;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;

  // Indian Phone Number Prefixes
  static const List<String> validPhonePrefixes = ['6', '7', '8', '9'];

  // Roles
  static const String roleMember = 'member';
  static const String roleAshaWorker = 'asha_worker';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;
}
