import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/record_provider.dart';
import '../../models/medical_record_model.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({super.key});

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {

  final _doctorController = TextEditingController();
  final _diagnosisController = TextEditingController();

  String? selectedReportType;
  String? selectedFilePath;
  String? selectedFileName;

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

            GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
                );

                if (result != null) {
                  setState(() {
                    selectedFilePath = result.files.single.path;
                    selectedFileName = result.files.single.name;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedFileName ?? 'Select PDF/Image Report',
                      style: TextStyle(
                        color: selectedFileName != null ? AppTheme.primaryColor : null,
                        fontWeight: selectedFileName != null ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            CustomButton(
              label: 'Upload Report',
              onPressed: () async {
                if (_doctorController.text.isEmpty || _diagnosisController.text.isEmpty || selectedReportType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final record = MedicalRecordModel(
                  recordId: 0,
                  recordType: selectedReportType!,
                  fileUrl: '',
                  diagnosis: _diagnosisController.text,
                  doctorName: _doctorController.text,
                  recordDate: DateTime.now(),
                );

                try {
                  await context.read<RecordProvider>().addRecord(record, filePath: selectedFilePath);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report saved successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save report: $e')),
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