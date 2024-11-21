import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

// ignore: must_be_immutable
class TankListPage2 extends StatefulWidget {
  final User user;

  const TankListPage2({
    super.key,
    required this.user,
  });

  @override
  TankListPage2State createState() => TankListPage2State();
}

class TankListPage2State extends State<TankListPage2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                          'Tanks',
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
          Expanded(
            child: Container(
              //color: Colors.orange,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff282a29),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('My Lovely Tank',
                                            style: TextStyle(
                                                fontFamily: 'NotoSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff282a29))),
                                                const SizedBox(width: 5),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                             color: Colors.lightBlue,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: const Text('Freshwater',
                                              style: TextStyle(
                                                  fontFamily: 'NotoSans',
                                                  fontSize: 10,
                                                  color: Color(0xffffffff))),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        DateFormat('MMMM d, yyyy')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontSize: 14,
                                            color: Color(0xff282a29))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                child: const Icon(
                                  Ionicons.chevron_forward_circle_outline,
                                  color: Color(0xff282a29),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
          )
        ],
      )),
    );
  }
}
