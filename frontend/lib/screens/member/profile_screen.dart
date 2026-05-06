import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user = context.read<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 45,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                user?.name.substring(0, 1) ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 20),

            CustomCard(
              child: Column(
                children: [

                  _buildTile('Full Name', user?.name ?? ''),
                  _buildTile('Phone', user?.phone ?? ''),
                  _buildTile('Role', user?.role ?? ''),
                  _buildTile('Village', user?.village ?? ''),
                  _buildTile('Blood Group', user?.bloodGroup ?? ''),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value))
        ],
      ),
    );
  }
}