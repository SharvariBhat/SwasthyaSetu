import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_card.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Reminders'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          _buildReminder(
            title: 'Take Diabetes Medicine',
            time: '8:00 AM',
          ),

          const SizedBox(height: 12),

          _buildReminder(
            title: 'Doctor Checkup',
            time: '2:00 PM',
          ),
        ],
      ),
    );
  }

  Widget _buildReminder({
    required String title,
    required String time,
  }) {
    return CustomCard(
      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(time)
              ],
            ),
          )
        ],
      ),
    );
  }
}