import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  bool _loggedIn = false;
  bool _loading = true;
  late User _user;

  LoginState() {
    loginState();
  }

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  User currentUser() => _user;

  void login() async {
    _loading = true;
    notifyListeners();

    _user = (await _handleSignIn())!;

    _loading = true;
    _loggedIn = true;
    _prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  void logout() {
    _prefs.clear();
    _loggedIn = false;
    _googleSignIn.signOut();
    _loading = false;
    notifyListeners();
  }

  Future<User?> _handleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    return user;
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _user = _auth.currentUser!;
      // ignore: unnecessary_null_comparison
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}
