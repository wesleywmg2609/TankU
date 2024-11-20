import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Page4 extends StatefulWidget {
  final User user;

  Page4({
    super.key,
    required this.user,
  });

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const SafeArea(
            child: Column(
          children: [
            Expanded(child: Center()),
          ],
        )));
  }
}
