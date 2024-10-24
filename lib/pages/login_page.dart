import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            onLoginSuccess();
          },
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.blue)),
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}
