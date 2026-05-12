import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/report_provider.dart';
import '../../widgets/custom_card.dart';

class ReportAnalysisScreen extends StatelessWidget {
  const ReportAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Analysis Results'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<ReportProvider>(
          builder: (context, reportProvider, _) {
            final result = reportProvider.analysisResult;

            if (result == null) {
              return Center(
                child: Text(
                  'No analysis results available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.warningColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_outlined,
                            color: AppTheme.warningColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This analysis is for informational purposes only. Please consult a healthcare professional for medical advice.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.warningColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Detected Diseases
                    if (result['diseases'] != null && (result['diseases'] as List).isNotEmpty)
                      _buildSection(
                        context,
                        title: 'Detected Conditions',
                        icon: Icons.medical_information_outlined,
                        items: result['diseases'],
                      ),

                    // Medicines
                    if (result['medicines'] != null && (result['medicines'] as List).isNotEmpty)
                      _buildSection(
                        context,
                        title: 'Medicines Found',
                        icon: Icons.medication_outlined,
                        items: result['medicines'],
                      ),

                    // Abnormal Values
                    if (result['abnormalValues'] != null && (result['abnormalValues'] as List).isNotEmpty)
                      _buildSection(
                        context,
                        title: 'Abnormal Values',
                        icon: Icons.trending_up_outlined,
                        items: result['abnormalValues'],
                      ),

                    // Severity
                    if (result['severity'] != null)
                      _buildSeverityCard(context, result['severity']),

                    // Follow-up Suggestions
                    if (result['followUpSuggestions'] != null)
                      _buildSuggestionsCard(context, result['followUpSuggestions']),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                            ),
                            child: const Text('Save Report'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Upload Another'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<dynamic> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomCard(
              child: Text(
                item.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSeverityCard(BuildContext context, String severity) {
    Color severityColor = AppTheme.successColor;
    if (severity.toLowerCase().contains('high')) {
      severityColor = AppTheme.errorColor;
    } else if (severity.toLowerCase().contains('medium')) {
      severityColor = AppTheme.warningColor;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity Level',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        CustomCard(
          backgroundColor: severityColor.withOpacity(0.1),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: severityColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                severity,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: severityColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSuggestionsCard(BuildContext context, dynamic suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow-up Suggestions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        CustomCard(
          backgroundColor: AppTheme.primaryLight,
          child: Text(
            suggestions.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
