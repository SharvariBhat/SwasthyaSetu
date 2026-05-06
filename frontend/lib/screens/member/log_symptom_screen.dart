import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class LogSymptomScreen extends StatefulWidget {
  const LogSymptomScreen({super.key});

  @override
  State<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends State<LogSymptomScreen> {

  final _symptomController = TextEditingController();

  String? selectedSeverity;

  final severities = [
    'LOW',
    'MEDIUM',
    'HIGH'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Log Symptoms'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CustomTextField(
              label: 'Symptoms',
              hint: 'Example: Fever, headache...',
              controller: _symptomController,
              maxLines: 4,
              prefixIcon: const Icon(Icons.sick_outlined),
            ),

            const SizedBox(height: 20),

            CustomDropdown(
              label: 'Severity',
              items: severities,
              value: selectedSeverity,
              onChanged: (value) {
                setState(() {
                  selectedSeverity = value;
                });
              },
            ),

            const SizedBox(height: 30),

            CustomButton(
              label: 'Save Symptom',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}