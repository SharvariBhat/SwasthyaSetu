import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/report_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import 'report_analysis_screen.dart';

class UploadReportScreen extends StatefulWidget {
  const UploadReportScreen({Key? key}) : super(key: key);

  @override
  State<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends State<UploadReportScreen> {
  String? _selectedFilePath;
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Upload Medical Report'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                CustomCard(
                  backgroundColor: AppTheme.primaryLight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Upload your medical reports (PDF, JPG, PNG) for AI analysis',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // File Selection Area
                GestureDetector(
                  onTap: _selectFile,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.primaryLight.withOpacity(0.3),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFileName ?? 'Tap to select a file',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PDF, JPG, or PNG (Max 10MB)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Upload Progress
                Consumer<ReportProvider>(
                  builder: (context, reportProvider, _) {
                    if (reportProvider.isLoading && reportProvider.uploadProgress > 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uploading...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: reportProvider.uploadProgress / 100,
                              minHeight: 8,
                              backgroundColor: AppTheme.borderColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${reportProvider.uploadProgress}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Analysis Loading
                Consumer<ReportProvider>(
                  builder: (context, reportProvider, _) {
                    if (reportProvider.isAnalyzing) {
                      return Column(
                        children: [
                          CustomCard(
                            child: Column(
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Analyzing your report with AI...',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Error Message
                Consumer<ReportProvider>(
                  builder: (context, reportProvider, _) {
                    if (reportProvider.errorMessage != null) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.errorColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.errorColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    reportProvider.errorMessage!,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.errorColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Upload Button
                Consumer<ReportProvider>(
                  builder: (context, reportProvider, _) {
                    return CustomButton(
                      label: 'Analyze Report',
                      onPressed: () => _uploadReport(context),
                      isLoading: reportProvider.isLoading,
                      isEnabled: _selectedFilePath != null && !reportProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting file: $e')),
      );
    }
  }

  Future<void> _uploadReport(BuildContext context) async {
    if (_selectedFilePath == null) return;

    final reportProvider = context.read<ReportProvider>();
    final success = await reportProvider.uploadAndAnalyzeReport(
      filePath: _selectedFilePath!,
      fileName: _selectedFileName!,
    );

    if (success && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ReportAnalysisScreen(),
        ),
      );
    }
  }
}
