import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadirin/services/user_service.dart';
import 'package:hadirin/widgets/main_card.dart';
import 'package:hadirin/widgets/profile_info.dart';
import 'package:hadirin/widgets/theme_toggle.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final UserService userService = Get.find<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hadirin'),
        actions: [
          ThemeToggle(),
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                ProfileInfo(userService: userService),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              );
            },
            icon: Icon(Icons.person_outline),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 16),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainCard(userService: userService),
            // History
            const SizedBox(height: 24),
            Text(
              'Your History',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
