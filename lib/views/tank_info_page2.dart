import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/widgets/my_app_bar2.dart';
import 'package:tanku/widgets/my_button2.dart';
import 'package:tanku/widgets/my_nav_bar.dart';

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
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    //_pageController.jumpToPage(index);
  }

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
            icon: Ionicons.add_circle_outline,
            onTap: () {},
            isBackAllowed: true,
          ),
          Expanded(
            child: Container(
              //color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: const Color(0xff282a29),
                                child: widget.tank.imageUrl != null &&
                                        widget.tank.imageUrl!.isNotEmpty
                                    ? ClipOval(
                                        child: Image.network(
                                          widget.tank.imageUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Ionicons.fish, size: 48,),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Text('Freshwater',
                                          style: TextStyle(
                                              fontFamily: 'NotoSans',
                                              fontSize: 12,
                                              color: Color(0xffffffff))),
                                    ),
                                    Text(
                                        DateFormat('MMMM d, yyyy').format(
                                            convertFromIso8601String(
                                                widget.tank.setupAt)),
                                        style: const TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontSize: 16,
                                            color: Color(0xff282a29))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Container()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          MyNavBar2(buttons: [
            MyButton2(
                icon: Ionicons.fish_outline,
                iconPressed: Ionicons.fish,
                labelText: 'Tanks',
                isPressed: _selectedIndex == 0,
                onTap: () => _onItemTapped(0)),
            MyButton2(
                icon: Ionicons.calendar_number_outline,
                iconPressed: Ionicons.calendar_number,
                labelText: 'Calendar',
                isPressed: _selectedIndex == 1,
                onTap: () => _onItemTapped(1)),
            MyButton2(
                icon: Ionicons.people_outline,
                iconPressed: Ionicons.people,
                labelText: 'Community',
                isPressed: _selectedIndex == 2,
                onTap: () => _onItemTapped(2)),
            MyButton2(
                icon: Ionicons.grid_outline,
                iconPressed: Ionicons.grid,
                labelText: 'More',
                isPressed: _selectedIndex == 3,
                onTap: () => _onItemTapped(3)),
          ])
        ],
      )),
    );
  }
}
