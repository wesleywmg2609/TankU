import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

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
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            // color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Container(
                // color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff282a29)),
                        ),
                        Text(
                          'Good Morning!',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                              color: Color(0xff282a29)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: const Icon(
                        Ionicons.add_circle_outline,
                        color: Color(0xff282a29),
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
