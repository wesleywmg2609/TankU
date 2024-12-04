import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tanku/auth/auth.dart';
import 'package:tanku/auth/login_or_register.dart';
import 'package:tanku/views/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _updateSystemUIColors();
    Future.delayed(const Duration(seconds: 3), _routeUser);
  }

  void _updateSystemUIColors() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xfff6f6f6),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xfff6f6f6),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xffffffff),
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    super.dispose();
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
    
    return const Scaffold(
      backgroundColor: Color(0xfff6f6f6),
    );
  }
}
