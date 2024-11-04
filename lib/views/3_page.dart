import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Page3 extends StatefulWidget {
  final User user;

  Page3({
    super.key,
    required this.user,
  });

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: Column(
          children: [
            Expanded(child: Center()),
          ],
        )));
  }
}
