import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATHLOS'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 100, color: const Color(0xFFFFD600)),
            const SizedBox(height: 20),
            Text('Welcome to ATHLOS!', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'You have successfully logged in.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/login'),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
