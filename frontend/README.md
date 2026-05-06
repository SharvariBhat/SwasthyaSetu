# SwasthyaSetu - Rural Healthcare Mobile Application

A Flutter mobile application for a rural healthcare system designed with clean architecture, reusable components, and perfect validation.

## 📋 Project Overview

SwasthyaSetu is a healthcare management system built for rural areas with two user roles:
- **Members**: Patients who can track medicines, view lab reports, log symptoms, and receive reminders
- **ASHA Workers**: Healthcare workers who can manage members from their village

## 🏗️ Project Structure

```
frontend/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── config/
│   │   ├── constants/
│   │   │   └── app_constants.dart        # App-wide constants
│   │   └── theme/
│   │       └── app_theme.dart            # Theme configuration
│   ├── models/
│   │   └── user_model.dart               # User data model
│   ├── providers/
│   │   └── auth_provider.dart            # State management for auth
│   ├── services/
│   │   ├── api_service.dart              # HTTP client with Dio
│   │   └── auth_service.dart             # Authentication logic
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart         # Login UI
│   │   │   └── register_screen.dart      # Registration UI
│   │   └── dashboard/
│   │       └── member_dashboard.dart     # Member dashboard
│   ├── utils/
│   │   └── validators.dart               # Input validation logic
│   └── widgets/
│       ├── custom_button.dart            # Reusable button
│       ├── custom_card.dart              # Reusable card
│       ├── custom_dropdown.dart          # Reusable dropdown
│       ├── custom_text_field.dart        # Reusable text field
│       ├── error_message.dart            # Error display widget
│       └── loading_indicator.dart        # Loading spinner
├── pubspec.yaml                          # Dependencies
├── .env                                  # Environment variables
└── README.md                             # This file
```

## 🎨 Design System

### Color Palette
- **Primary**: Emerald Green (#10B981) - Main brand color
- **Secondary**: Blue (#3B82F6) - Secondary actions
- **Accent**: Amber (#F59E0B) - Highlights
- **Error**: Red (#EF4444) - Error states
- **Success**: Green (#10B981) - Success states
- **Background**: Off-white (#FAFAFA) - Page background
- **Surface**: White (#FFFFFF) - Card/component background

### Typography
- **Font Family**: Poppins
- **Display Large**: 32px, Bold
- **Display Medium**: 28px, Bold
- **Headline Small**: 20px, Semi-bold
- **Title Large**: 16px, Semi-bold
- **Body Large**: 16px, Regular
- **Body Medium**: 14px, Regular
- **Label Small**: 12px, Medium

### Components
- **Border Radius**: 12px (default)
- **Padding**: 16px (default)
- **Elevation**: 2-4px (cards)
- **Soft Gradients**: Emerald gradient for primary actions

## 🔐 Validation Rules

### Email Validation
- Must contain `@` symbol
- Valid domain format (e.g., user@example.com)
- Regex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

### Phone Number Validation
- Exactly 10 digits
- Must start with 6, 7, 8, or 9 (Indian numbers)
- No spaces or special characters allowed
- Example: 9876543210

### Aadhaar Validation
- Exactly 12 digits
- Only numeric characters
- Example: 123456789012

### Password Validation
- Minimum 6 characters
- Maximum 20 characters

### Full Name Validation
- Minimum 3 characters
- Only letters and spaces allowed

### Age Validation
- Numeric value between 1-150

## 📦 Dependencies

```yaml
flutter: SDK
provider: ^6.0.0          # State management
dio: ^5.3.1               # HTTP client
intl: ^0.19.0             # Internationalization
shared_preferences: ^2.2.2 # Local storage
flutter_dotenv: ^5.1.0    # Environment variables
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for emulator)

### Installation

1. **Clone the repository**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update `.env` file with your API base URL
   ```
   API_BASE_URL=http://localhost:5000/api
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screens Implemented

### 1. Login Screen (`screens/auth/login_screen.dart`)
- Email and password input fields
- Form validation
- Error message display
- Loading state
- Link to registration screen

**Features:**
- Email validation with @ symbol check
- Password visibility toggle
- Error handling with dismissible messages
- Loading indicator during login

### 2. Registration Screen (`screens/auth/register_screen.dart`)
- Multi-field form with step indicator
- Role selection (Member/ASHA Worker)
- Personal information (name, email, phone, age)
- Aadhaar number input
- Health information (gender, blood group, chronic disease)
- Village selection (dropdown)
- Password confirmation

**Features:**
- Perfect validation for all fields
- Phone number: 10 digits, starts with 6/7/8/9
- Aadhaar: 12 digits
- Email: Must contain @
- Password confirmation matching
- Chronic disease checkbox
- Responsive layout

### 3. Member Dashboard (`screens/dashboard/member_dashboard.dart`)
- Welcome greeting with user name
- Quick stats (medicines, appointments, reports)
- Quick action buttons
- Upcoming reminders section
- Recent lab reports
- Menu with profile, settings, and logout

**Features:**
- User-specific greeting
- Quick access to main features
- Reminder cards with time and type
- Report cards with status
- Bottom menu with logout confirmation

## 🔧 Reusable Widgets

### CustomTextField
```dart
CustomTextField(
  label: 'Email',
  hint: 'Enter your email',
  controller: controller,
  validator: Validators.validateEmail,
  prefixIcon: Icon(Icons.email_outlined),
)
```

### CustomButton
```dart
CustomButton(
  label: 'Login',
  onPressed: () {},
  isLoading: false,
  isEnabled: true,
)
```

### CustomDropdown
```dart
CustomDropdown(
  label: 'Gender',
  items: ['Male', 'Female', 'Other'],
  onChanged: (value) {},
  validator: Validators.validateDropdown,
)
```

### CustomCard
```dart
CustomCard(
  child: Text('Card content'),
  padding: EdgeInsets.all(16),
  borderRadius: 12,
)
```

### ErrorMessage
```dart
ErrorMessage(
  message: 'An error occurred',
  onDismiss: () {},
)
```

### LoadingIndicator
```dart
LoadingIndicator(
  message: 'Loading...',
  size: 50,
)
```

## 🔌 API Integration

### ApiService (`services/api_service.dart`)
- Centralized HTTP client using Dio
- Automatic token injection in headers
- Error handling
- File upload support
- Configurable timeouts

### AuthService (`services/auth_service.dart`)
- Login/Register endpoints
- Token management
- Local storage with SharedPreferences
- User data persistence

### AuthProvider (`providers/auth_provider.dart`)
- State management for authentication
- Loading states
- Error handling
- User data access

## 📝 Validation Examples

### Email Validation
```dart
Validators.validateEmail('user@example.com') // null (valid)
Validators.validateEmail('invalid-email')    // Error message
```

### Phone Number Validation
```dart
Validators.validatePhoneNumber('9876543210')  // null (valid)
Validators.validatePhoneNumber('1234567890')  // Error: must start with 6/7/8/9
Validators.validatePhoneNumber('98765432')    // Error: must be 10 digits
```

### Aadhaar Validation
```dart
Validators.validateAadhaar('123456789012')    // null (valid)
Validators.validateAadhaar('12345678901')     // Error: must be 12 digits
```

## 🎯 Next Steps

### Screens to Implement
1. **ASHA Worker Dashboard** - Village-based member filtering
2. **Medicine Tracking Screen** - Add/edit/delete medicines
3. **Lab Report Upload** - File upload with preview
4. **Symptom Logging** - Daily check-in form
5. **Reminder Management** - Create and manage reminders
6. **Profile Screen** - View and edit user information

### Features to Add
1. Offline support with local database
2. Push notifications for reminders
3. Image capture for lab reports
4. PDF generation for reports
5. Dark mode support
6. Multi-language support

## 🐛 Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter run

# For iOS
cd ios
pod install
cd ..
flutter run
```

### API Connection Issues
- Verify `.env` file has correct API_BASE_URL
- Ensure backend server is running
- Check network connectivity
- Review API response in console

## 📄 License

This project is part of the SwasthyaSetu rural healthcare initiative.

## 👥 Contributing

For development guidelines and contribution process, please refer to the main project documentation.

---

**Last Updated**: May 2026
**Version**: 1.0.0
