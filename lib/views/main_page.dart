import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/views/tank_list_page.dart%20copy.dart';
import 'package:tanku/widgets/my_icon.dart';
import 'package:tanku/widgets/my_nav_bar.dart';
import 'package:tanku/views/calendar_page.dart';
import 'package:tanku/views/3_page.dart';
import 'package:tanku/views/4_page.dart';
import 'package:tanku/views/add_tank_page.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({super.key, required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> pageConfigs = [
      {
        'title': 'Tanks',
        'trailing': const MyIcon(icon: Icons.add),
        'onTrailingPressed': () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTankPage(
                        user: widget.user,
                      )));
        },
        'page': TankListPage2(user: widget.user),
      },
      {
        'title': 'Calendar',
        'trailing': null,
        'onTrailingPressed': null,
        'page': CalendarPage(user: widget.user),
      },
      {
        'title': 'Page 3',
        'trailing': null,
        'onTrailingPressed': null,
        'page': Page3(user: widget.user),
      },
      {
        'title': 'Page 4',
        'trailing': null,
        'onTrailingPressed': null,
        'page': Page4(user: widget.user),
      },
    ];

    return Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: pageConfigs
                      .map((config) => config['page'] as Widget)
                      .toList(),
                ),
              ),
              MyNavBar2(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ],
          ),
        ));
  }
}
