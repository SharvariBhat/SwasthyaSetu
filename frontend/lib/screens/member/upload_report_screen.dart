import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({super.key});

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {

  final _doctorController = TextEditingController();
  final _diagnosisController = TextEditingController();

  String? selectedReportType;

  final reportTypes = [
    'LAB_REPORT'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Upload Medical Record'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CustomDropdown(
              label: 'Report Type',
              items: reportTypes,
              value: selectedReportType,
              onChanged: (value) {
                setState(() {
                  selectedReportType = value;
                });
              },
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Doctor Name',
              hint: 'Enter doctor name',
              controller: _doctorController,
              prefixIcon: const Icon(Icons.person_outline),
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'Diagnosis',
              hint: 'Enter diagnosis',
              controller: _diagnosisController,
              maxLines: 4,
              prefixIcon: const Icon(Icons.description_outlined),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 50,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: 12),
                  Text('Select PDF/Image Report')
                ],
              ),
            ),

            const SizedBox(height: 30),

            CustomButton(
              label: 'Upload Report',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}