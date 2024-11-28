import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/views/tank_list_page.dart%20copy.dart';
import 'package:tanku/widgets/my_button2.dart';
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
                buttons: [
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
                ],
              ),
            ],
          ),
        ));
  }
}
