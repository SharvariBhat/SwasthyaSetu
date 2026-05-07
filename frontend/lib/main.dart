import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/theme/app_theme.dart';
import 'config/localization/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/language_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/member_dashboard.dart';
import 'core/routes/app_router.dart';
import 'providers/medicine_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/record_provider.dart';
import 'providers/symptom_provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => MedicineProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ReminderProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RecordProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SymptomProvider(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp(
            title: 'SwasthyaSetu',
            theme: AppTheme.lightTheme,
            locale: languageProvider.locale,
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('ta'),
              Locale('te'),
              Locale('kn'),
              Locale('ml'),
            ],
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isAuthenticated) {
                  return const MemberDashboard();
                }
                return LoginScreen();
              },
            ),
            debugShowCheckedModeBanner: false,
            onGenerateRoute:
              AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}