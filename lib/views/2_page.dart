import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Page2 extends StatefulWidget {
  final User user;

  Page2({
    super.key,
    required this.user,
  });

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {

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
