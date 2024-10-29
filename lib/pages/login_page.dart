import 'package:expense_app/state/login_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TapGestureRecognizer _recognizer1;
  late TapGestureRecognizer _recognizer2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Flex(direction: Axis.vertical),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              'Expense-Manager',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/graph.png'),
            ),
            Text(
              'Your personal finance app',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Consumer<LoginState>(
              builder: (BuildContext context, value, child) {
                if (value.isLoading()) {
                  return const CircularProgressIndicator();
                } else {
                  return child!;
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false).login();
                },
                child: const Text('Sign in with Google'),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  text: 'To use this app you need to agree to our ',
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      //recognizer: _recognizer1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      //recognizer: _recognizer2,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
