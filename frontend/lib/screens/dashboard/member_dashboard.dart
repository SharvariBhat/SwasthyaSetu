import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme/app_theme.dart';

import '../../providers/auth_provider.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/record_provider.dart';
import '../../providers/symptom_provider.dart';

import '../../widgets/custom_card.dart';

import '../member/add_medicine_screen.dart';
import '../member/upload_report_screen.dart';
import '../member/log_symptom_screen.dart';
import '../member/reminder_screen.dart';
import '../member/profile_screen.dart';

class MemberDashboard extends StatefulWidget {

  const MemberDashboard({Key? key})
      : super(key: key);

  @override
  State<MemberDashboard> createState() =>
      _MemberDashboardState();
}

class _MemberDashboardState
    extends State<MemberDashboard> {

  @override
  void initState() {

    super.initState();

    Future.microtask(() {

      context
          .read<MedicineProvider>()
          .fetchMedicines();

      context
          .read<ReminderProvider>()
          .fetchReminders();

      context
          .read<RecordProvider>()
          .fetchRecords();

      context
          .read<SymptomProvider>()
          .fetchSymptoms();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppTheme.backgroundColor,

      appBar: AppBar(

        title:
            const Text('SwasthyaSetu'),

        elevation: 0,

        actions: [

          IconButton(

            icon: const Icon(
              Icons.notifications_outlined,
            ),

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      const ReminderScreen(),
                ),
              );
            },
          ),

          IconButton(

            icon: const Icon(Icons.menu),

            onPressed: () =>
                _showMenu(context),
          ),
        ],
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// WELCOME SECTION
                Consumer<AuthProvider>(

                  builder: (

                    context,

                    authProvider,

                    _,
                  ) {

                    return Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(

                          'Welcome back!',

                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),

                        const SizedBox(height: 4),

                        Text(

                          authProvider.user?.name ??
                              'User',

                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(

                                fontWeight:
                                    FontWeight.w700,
                              ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// QUICK STATS
                Consumer4<
                    MedicineProvider,
                    ReminderProvider,
                    RecordProvider,
                    SymptomProvider>(

                  builder: (

                    context,

                    medicineProvider,

                    reminderProvider,

                    recordProvider,

                    symptomProvider,

                    _,
                  ) {

                    return Row(

                      children: [

                        Expanded(

                          child: _buildStatCard(

                            context,

                            icon:
                                Icons.medication_outlined,

                            label: 'Medicines',

                            value:
                                medicineProvider
                                    .medicines
                                    .length
                                    .toString(),

                            color:
                                AppTheme.primaryColor,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: _buildStatCard(

                            context,

                            icon:
                                Icons.notifications,

                            label: 'Reminders',

                            value:
                                reminderProvider
                                    .reminders
                                    .length
                                    .toString(),

                            color:
                                AppTheme.secondaryColor,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: _buildStatCard(

                            context,

                            icon:
                                Icons.description_outlined,

                            label: 'Reports',

                            value:
                                recordProvider
                                    .records
                                    .length
                                    .toString(),

                            color:
                                AppTheme.accentColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// QUICK ACTIONS
                Text(

                  'Quick Actions',

                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 12),

                _buildActionButton(

                  context,

                  icon:
                      Icons.add_circle_outline,

                  label: 'Add Medicine',

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const AddMedicineScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildActionButton(

                  context,

                  icon:
                      Icons.upload_file_outlined,

                  label:
                      'Upload Lab Report',

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const UploadReportScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildActionButton(

                  context,

                  icon:
                      Icons.assignment_outlined,

                  label:
                      'Log Symptoms',

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>
                            const LogSymptomScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// REMINDERS
                Text(

                  'Upcoming Reminders',

                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 12),

                Consumer<ReminderProvider>(

                  builder: (

                    context,
                    reminderProvider,
                    _,
                  ) {

                    if (reminderProvider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (reminderProvider.reminders.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Text('No upcoming reminders')),
                      );
                    }

                    return Column(

                      children:
                          reminderProvider
                              .reminders
                              .map(

                        (reminder) {

                          return Padding(

                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),

                            child:
                                _buildReminderCard(

                              context,

                              title:
                                  reminder.title ?? reminder.type,

                              time:
                                  reminder
                                      .reminderTime,

                              type:
                                  reminder.type,
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),

                const SizedBox(height: 28),

                /// REPORTS
                Text(

                  'Recent Lab Reports',

                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 12),

                Consumer<RecordProvider>(

                  builder: (

                    context,

                    recordProvider,

                    _,
                  ) {

                    if (recordProvider
                        .isLoading) {

                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    return Column(

                      children:
                          recordProvider
                              .records
                              .map(

                        (record) {

                          return Padding(

                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),

                            child:
                                _buildReportCard(

                              context,

                              title:
                                  record.recordType,

                              date:
                                  record.recordDate
                                          ?.toString()
                                          .split(' ')[0] ??
                                      '',

                              status:
                                  record.diagnosis,
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {

    required IconData icon,

    required String label,

    required String value,

    required Color color,
  }) {

    return CustomCard(

      backgroundColor:
          color.withOpacity(0.1),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(

            value,

            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(

                  color: color,

                  fontWeight:
                      FontWeight.w700,
                ),
          ),

          const SizedBox(height: 4),

          Text(

            label,

            style: Theme.of(context)
                .textTheme
                .labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {

    required IconData icon,

    required String label,

    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: CustomCard(

        child: Row(

          children: [

            Icon(

              icon,

              color:
                  AppTheme.primaryColor,

              size: 24,
            ),

            const SizedBox(width: 16),

            Text(

              label,

              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const Spacer(),

            const Icon(

              Icons.arrow_forward_ios,

              size: 16,

              color:
                  AppTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    BuildContext context, {

    required String title,

    required String time,

    required String type,
  }) {

    return CustomCard(

      child: Row(

        children: [

          Container(

            padding:
                const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color:
                  AppTheme.primaryLight,

              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: const Icon(

              Icons.alarm,

              color:
                  AppTheme.primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 4),

                Text(

                  time,

                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),

          Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color:
                  AppTheme.primaryLight,

              borderRadius:
                  BorderRadius.circular(6),
            ),

            child: Text(

              type,

              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(

                    color:
                        AppTheme.primaryColor,

                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {

    required String title,

    required String date,

    required String status,
  }) {

    return CustomCard(

      child: Row(

        children: [

          Container(

            padding:
                const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color:
                  AppTheme.primaryLight,

              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: const Icon(

              Icons.description,

              color:
                  AppTheme.primaryColor,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 4),

                Text(

                  date,

                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ),
          ),

          Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: AppTheme
                  .successColor
                  .withOpacity(0.1),

              borderRadius:
                  BorderRadius.circular(6),
            ),

            child: Text(

              status,

              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(

                    color:
                        AppTheme.successColor,

                    fontWeight:
                        FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(
      BuildContext context) {

    showModalBottomSheet(

      context: context,

      builder: (context) => Container(

        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            ListTile(

              leading:
                  const Icon(Icons.person_outline),

              title:
                  const Text('Profile'),

              onTap: () {

                Navigator.pop(context);

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ProfileScreen(),
                  ),
                );
              },
            ),

            ListTile(

              leading:
                  const Icon(Icons.notifications),

              title:
                  const Text('Reminders'),

              onTap: () {

                Navigator.pop(context);

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        const ReminderScreen(),
                  ),
                );
              },
            ),

            ListTile(

              leading:
                  const Icon(Icons.settings),

              title:
                  const Text('Settings'),

              onTap: () {

                Navigator.pop(context);
              },
            ),

            ListTile(

              leading:
                  const Icon(Icons.help_outline),

              title:
                  const Text('Help & Support'),

              onTap: () {

                Navigator.pop(context);
              },
            ),

            const Divider(),

            ListTile(

              leading: const Icon(

                Icons.logout,

                color:
                    AppTheme.errorColor,
              ),

              title: const Text(

                'Logout',

                style: TextStyle(
                  color:
                      AppTheme.errorColor,
                ),
              ),

              onTap: () {

                Navigator.pop(context);

                _handleLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(
      BuildContext context) {

    showDialog(

      context: context,

      builder: (context) => AlertDialog(

        title:
            const Text('Logout'),

        content: const Text(
          'Are you sure you want to logout?',
        ),

        actions: [

          TextButton(

            onPressed: () =>
                Navigator.pop(context),

            child:
                const Text('Cancel'),
          ),

          TextButton(

            onPressed: () {

              context
                  .read<AuthProvider>()
                  .logout();

              Navigator.pop(context);
            },

            child: const Text(

              'Logout',

              style: TextStyle(
                color:
                    AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}