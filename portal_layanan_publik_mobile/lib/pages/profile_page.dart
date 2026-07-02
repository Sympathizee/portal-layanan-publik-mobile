import 'package:flutter/material.dart';
import '../core/widgets/navigation/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        leading: SizedBox.shrink(),
      ),
      body: const Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
