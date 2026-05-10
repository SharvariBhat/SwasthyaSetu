import 'package:flutter/material.dart';
import '../../config/theme/app_theme.dart';
import '../../widgets/custom_card.dart';
import 'package:provider/provider.dart';
import '../../providers/reminder_provider.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Reminders'),
      ),

      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.reminders.isEmpty) {
            return const Center(child: Text('No reminders found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.reminders.length,
            itemBuilder: (context, index) {
              final reminder = provider.reminders[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildReminder(
                  title: reminder.type,
                  time: reminder.reminderTime,
                ),
              );
            },
          );
        },
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