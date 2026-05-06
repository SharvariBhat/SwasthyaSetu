import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {

  final _medicineController = TextEditingController();
  final _dosageController = TextEditingController();

  String? selectedTiming;
  String? selectedFrequency;

  final timings = [
    'Morning',
    'Afternoon',
    'Night'
  ];

  final frequencies = [
    'Daily',
    'Twice Daily',
    'Weekly'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CustomTextField(
              label: 'Medicine Name',
              hint: 'Enter medicine name',
              controller: _medicineController,
              prefixIcon: const Icon(Icons.medication_outlined),
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Dosage',
              hint: 'Example: 1 tablet',
              controller: _dosageController,
              prefixIcon: const Icon(Icons.local_hospital_outlined),
            ),

            const SizedBox(height: 20),

            CustomDropdown(
              label: 'Timing',
              items: timings,
              value: selectedTiming,
              onChanged: (value) {
                setState(() {
                  selectedTiming = value;
                });
              },
            ),

            const SizedBox(height: 20),

            CustomDropdown(
              label: 'Frequency',
              items: frequencies,
              value: selectedFrequency,
              onChanged: (value) {
                setState(() {
                  selectedFrequency = value;
                });
              },
            ),

            const SizedBox(height: 30),

            CustomButton(
              label: 'Save Medicine',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}