import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/auth/auth.dart';
import 'package:tankyou/auth/login_or_register.dart';
import 'package:tankyou/views/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), _routeUser);
  }

  void _routeUser() {
    final authenticated = checkIfUserSignedIn();

    if (authenticated) {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(
                user: currentUser,
              ),
            ));
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginOrRegister(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
