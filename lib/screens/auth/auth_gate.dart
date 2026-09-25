import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../widgets/section_header.dart';
import '../home/main_shell.dart';
import 'login_screen.dart';

/// Shows Login or Home based on Firebase Auth state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WellnessHeroIcon(),
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: AppColors.blush),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainShell();
        }

        return const LoginScreen();
      },
    );
  }
}
