import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/widgets/my_app_bar2.dart';

// ignore: must_be_immutable
class TankInfoPage2 extends StatefulWidget {
  User user;
  Tank tank;

  TankInfoPage2({
    super.key,
    required this.user,
    required this.tank,
  });

  @override
  State<TankInfoPage2> createState() => _TankInfoPage2State();
}

class _TankInfoPage2State extends State<TankInfoPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
          child: Column(
        children: [
          MyAppBar2(
            title: widget.tank.name,
            subtitle: 'Tank Info',
            onTap: () {},
            isBackAllowed: true,
          ),
          Expanded(
            child: Container(
              //color: Colors.green,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    // height: 100,
                    width: double.infinity,
                   color: Colors.orange,
                   child: const Padding(
                    padding: EdgeInsets.all(20)),
                  ),
                ),

              ]),
            ),
          )
        ],
      )),
    );
  }
}
