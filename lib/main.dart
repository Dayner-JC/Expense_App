import 'package:expense_app/firebase/firebase_options.dart';
import 'package:expense_app/pages/add_page.dart';
import 'package:expense_app/pages/home_page.dart';
import 'package:expense_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) {
          return _loggedIn
              ? const HomePage()
              : LoginPage(
                  onLoginSuccess: () {
                    setState(() {
                      _loggedIn = true;
                    });
                  },
                );
        },
        '/add': (BuildContext context) => const AddPage()
      },
    );
  }
}
