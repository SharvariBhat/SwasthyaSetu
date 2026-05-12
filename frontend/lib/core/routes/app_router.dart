import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';

import '../../screens/dashboard/member_dashboard.dart';

import '../../screens/member/add_medicine_screen.dart';
import '../../screens/member/upload_report_screen.dart';
import '../../screens/member/log_symptom_screen.dart';
import '../../screens/member/reminder_screen.dart';
import '../../screens/member/profile_screen.dart';

import 'app_routes.dart';

class AppRouter {

  static Route generateRoute(
      RouteSettings settings) {

    switch (settings.name) {

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) =>
              const RegisterScreen(),
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) =>
              const MemberDashboard(),
        );

      case AppRoutes.addMedicine:
        return MaterialPageRoute(
          builder: (_) =>
              const AddMedicineScreen(),
        );

      case AppRoutes.uploadReport:
        return MaterialPageRoute(
          builder: (_) =>
              const UploadReportScreen(),
        );

      case AppRoutes.logSymptom:
        return MaterialPageRoute(
          builder: (_) =>
              const LogSymptomScreen(),
        );

      case AppRoutes.reminders:
        return MaterialPageRoute(
          builder: (_) =>
              const ReminderScreen(),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) =>
              const ProfileScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        );
    }
  }
}
