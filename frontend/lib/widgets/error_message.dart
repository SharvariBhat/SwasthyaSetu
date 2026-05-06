import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final bool showIcon;

  const ErrorMessage({
    Key? key,
    required this.message,
    this.onDismiss,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            const Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppTheme.errorColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: AppTheme.errorColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}
