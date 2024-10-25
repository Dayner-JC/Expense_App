import 'package:expense_app/state/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget? child) {
            return value.isLoading()
                ? const CircularProgressIndicator()
                : child!;
          },
          child: TextButton(
            onPressed: () {
              Provider.of<LoginState>(context, listen: false).login();
            },
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue)),
            child: const Text('Sign In'),
          ),
        ),
      ),
    );
  }
}
