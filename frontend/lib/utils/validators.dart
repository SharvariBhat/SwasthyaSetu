class Validators {
  /// Validates email format
  /// Must contain @ symbol and valid domain
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    // Check for @ symbol
    if (!value.contains('@')) {
      return 'Email must contain @ symbol';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates Indian phone number
  /// Must be 10 digits and start with 6, 7, 8, or 9
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any spaces or hyphens
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Check if it's exactly 10 digits
    if (cleanedValue.length != 10) {
      return 'Phone number must be 10 digits';
    }

    // Check if all characters are digits
    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'Phone number must contain only digits';
    }

    // Check if it starts with valid Indian prefix (6, 7, 8, 9)
    final firstDigit = cleanedValue[0];
    if (!['6', '7', '8', '9'].contains(firstDigit)) {
      return 'Indian phone number must start with 6, 7, 8, or 9';
    }

    return null;
  }

  /// Validates Aadhaar number
  /// Must be 12 digits
  static String? validateAadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar number is required';
    }

    final cleanedValue = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleanedValue.length != 12) {
      return 'Aadhaar number must be 12 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return 'Aadhaar number must contain only digits';
    }

    return null;
  }

  /// Validates password
  /// Minimum 6 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates confirm password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }

    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name must contain only letters and spaces';
    }

    return null;
  }

  /// Validates age
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < 1 || age > 150) {
      return 'Please enter a valid age (1-150)';
    }

    return null;
  }

  /// Validates that a field is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates dropdown selection
  static String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select a $fieldName';
    }
    return null;
  }
}
