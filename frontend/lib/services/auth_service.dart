import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../config/constants/app_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['user']);

        // Save token and user data
        await _saveToken(token);
        await _saveUser(user);
        _apiService.setToken(token);

        return {
          'success': true,
          'message': 'Login successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// Register user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String role,
    String? aadhaar,
    String? gender,
    int? age,
    String? village,
    String? bloodGroup,
    bool? hasChronicDisease,
    String? chronicDiseaseDetails,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.registerEndpoint,
        data: {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'role': role,
          'aadhaar': aadhaar,
          'gender': gender,
          'age': age,
          'village': village,
          'bloodGroup': bloodGroup,
          'hasChronicDisease': hasChronicDisease,
          'chronicDiseaseDetails': chronicDiseaseDetails,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['user']);

        // Save token and user data
        await _saveToken(token);
        await _saveUser(user);
        _apiService.setToken(token);

        return {
          'success': true,
          'message': 'Registration successful',
          'user': user,
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Registration failed',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['message'] ?? 'Error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);
    _apiService.clearToken();
  }

  /// Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  /// Get stored user
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      // Parse JSON and create User object
      // This is a simplified version - you might want to use json_serializable
      return null; // Implement proper JSON parsing
    }
    return null;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  /// Save user to SharedPreferences
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userKey, user.toJson().toString());
  }
}
