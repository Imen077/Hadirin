import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hadirin/services/user_service.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.userService});

  final UserService userService;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Transform.rotate(angle: math.pi / 2, child: Icon(Icons.chevron_left)),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 80,
            backgroundImage:
                userService.firestroreUser.value!.faceImageUrl == null
                ? NetworkImage(userService.firestroreUser.value!.faceImageUrl!)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            userService.firestroreUser.value!.displayName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            userService.firestroreUser.value!.email,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await userService.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
