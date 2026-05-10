import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../providers/symptom_provider.dart';
import '../../models/symptom_model.dart';

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
              onPressed: () async {
                if (_symptomController.text.isEmpty || selectedSeverity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final symptom = SymptomModel(
                  logId: 0,
                  symptom: _symptomController.text,
                  severity: selectedSeverity!,
                );

                try {
                  await context.read<SymptomProvider>().addSymptom(symptom);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Symptom saved successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save symptom: $e')),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}