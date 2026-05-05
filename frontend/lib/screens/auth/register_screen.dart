import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants/app_constants.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedRole;
  String? _selectedGender;
  String? _selectedVillage;
  String? _selectedBloodGroup;
  bool _hasChronicDisease = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Mock data - replace with API call
  final List<String> villages = [
    'Nandgaon',
    'Pimpri',
    'Talegaon',
    'Khed',
    'Junnar',
  ];

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> roles = ['Member', 'ASHA Worker'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aadhaarController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole == 'ASHA Worker'
            ? AppConstants.roleAshaWorker
            : AppConstants.roleMember,
        aadhaar: _aadhaarController.text.trim(),
        gender: _selectedGender,
        age: int.tryParse(_ageController.text),
        village: _selectedVillage,
        bloodGroup: _selectedBloodGroup,
        hasChronicDisease: _hasChronicDisease,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Step Indicator
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fill in your details to create an account',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Full Name
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: _fullNameController,
                    validator: Validators.validateFullName,
                    prefixIcon: const Icon(Icons.person_outline),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Phone Number
                  CustomTextField(
                    label: 'Phone Number',
                    hint: 'Enter 10-digit phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Aadhaar Number
                  CustomTextField(
                    label: 'Aadhaar Number',
                    hint: 'Enter 12-digit Aadhaar',
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    validator: Validators.validateAadhaar,
                    prefixIcon: const Icon(Icons.credit_card_outlined),
                    maxLength: 12,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Role Selection
                  CustomDropdown(
                    label: 'Select Role',
                    hint: 'Choose your role',
                    value: _selectedRole,
                    items: roles,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    validator: (value) => Validators.validateDropdown(value, 'role'),
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                  const SizedBox(height: 20),

                  // Gender
                  CustomDropdown(
                    label: 'Gender',
                    hint: 'Select your gender',
                    value: _selectedGender,
                    items: genders,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) => Validators.validateDropdown(value, 'gender'),
                    prefixIcon: const Icon(Icons.wc_outlined),
                  ),
                  const SizedBox(height: 20),

                  // Age
                  CustomTextField(
                    label: 'Age',
                    hint: 'Enter your age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    validator: Validators.validateAge,
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Village
                  CustomDropdown(
                    label: 'Village',
                    hint: 'Select your village',
                    value: _selectedVillage,
                    items: villages,
                    onChanged: (value) {
                      setState(() {
                        _selectedVillage = value;
                      });
                    },
                    validator: (value) => Validators.validateDropdown(value, 'village'),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  const SizedBox(height: 20),

                  // Blood Group
                  CustomDropdown(
                    label: 'Blood Group',
                    hint: 'Select your blood group',
                    value: _selectedBloodGroup,
                    items: bloodGroups,
                    onChanged: (value) {
                      setState(() {
                        _selectedBloodGroup = value;
                      });
                    },
                    validator: (value) => Validators.validateDropdown(value, 'blood group'),
                    prefixIcon: const Icon(Icons.bloodtype_outlined),
                  ),
                  const SizedBox(height: 20),

                  // Chronic Disease Checkbox
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      border: Border.all(color: AppTheme.borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      value: _hasChronicDisease,
                      onChanged: (value) {
                        setState(() {
                          _hasChronicDisease = value ?? false;
                        });
                      },
                      title: const Text('Do you have any chronic disease?'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: Validators.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 28),

                  // Error Message
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      if (authProvider.errorMessage != null) {
                        return Column(
                          children: [
                            ErrorMessage(
                              message: authProvider.errorMessage!,
                              onDismiss: () {
                                authProvider.clearError();
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Register Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return CustomButton(
                        label: 'Create Account',
                        onPressed: () => _handleRegister(context),
                        isLoading: authProvider.isLoading,
                        isEnabled: !authProvider.isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
