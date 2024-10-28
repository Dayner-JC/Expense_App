import 'package:expense_app/firebase/firebase_options.dart';
import 'package:expense_app/pages/datails_page.dart';
import 'package:expense_app/state/login_state.dart';
import 'package:expense_app/pages/home_page.dart';
import 'package:expense_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'My Expenses',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments as DetailsParams;
            return MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsPage(
                  params: params,
                );
              },
            );
          }
          return null;
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            return state.isLoggedIn() ? const HomePage() : const LoginPage();
          },
        },
      ),
    );
  }
}
