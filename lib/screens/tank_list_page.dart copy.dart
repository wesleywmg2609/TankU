import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/screens/add_tank_page.dart';
import 'package:tanku/services/tank_service.dart';

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
  late TankService _tankService;
  List<Tank?> _tanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _tankService.listenToAllTanksUpdates();

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tanks = _tankService.tanks;
          _isLoading = _tankService.isLoading;
        });
      }
    });
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
                      onTap: () {
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddTankPage(user: widget.user),
                            ),
                          );
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          Ionicons.add_circle_outline,
                          key: UniqueKey(),
                          color: const Color(0xff282a29),
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                  itemCount: _tanks.length,
                  itemBuilder: (context, index) {
                    var tank = _tanks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
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
                                onTap: () {
                                  setState(() {
                                    
                                  });
                                },
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    Ionicons.chevron_forward_circle_outline,
                                    key: UniqueKey(),
                                    color: const Color(0xff282a29),
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
