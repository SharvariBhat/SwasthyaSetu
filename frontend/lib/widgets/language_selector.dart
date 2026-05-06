import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../config/theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final bool isCompact;

  const LanguageSelector({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        if (isCompact) {
          // Compact version for top-right corner
          return PopupMenuButton<String>(
            onSelected: (String languageCode) {
              languageProvider.setLanguage(languageCode);
            },
            itemBuilder: (BuildContext context) {
              return languageProvider.supportedLanguages.map((lang) {
                return PopupMenuItem<String>(
                  value: lang['code']!,
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: languageProvider.locale.languageCode == lang['code']
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(lang['name']!),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, color: AppTheme.primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    languageProvider.locale.languageCode.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Full version for settings page
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: languageProvider.supportedLanguages.map((lang) {
                final isSelected =
                    languageProvider.locale.languageCode == lang['code'];
                return GestureDetector(
                  onTap: () {
                    languageProvider.setLanguage(lang['code']!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      lang['name']!,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
