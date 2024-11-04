import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_drawer.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_nav_bar.dart';
import 'package:tankyou/helper/widgets.dart';
import 'package:tankyou/views/2_page.dart';
import 'package:tankyou/views/3_page.dart';
import 'package:tankyou/views/4_page.dart';
import 'package:tankyou/views/add_tank_page.dart';
import 'package:tankyou/views/home_page.dart';
import 'package:tankyou/views/tank_list_page.dart.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({super.key, required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<TankListPageState> _tankListKey = GlobalKey();
  final ValueNotifier<bool> _isDrawerOpen = ValueNotifier<bool>(false);
  int _selectedIndex = 0;
  double _xOffset = 0;
  double _yOffset = 0;
  double _scaleFactor = 1;
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

  void _openDrawer() {
    setState(() {
      double screenHeight = MediaQuery.of(context).size.height;
      _scaleFactor = 0.8;
      _xOffset = 150;
      _yOffset = (screenHeight - (screenHeight * _scaleFactor)) / 2;
      _isDrawerOpen.value = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _xOffset = 0;
      _yOffset = 0;
      _scaleFactor = 1;
      _isDrawerOpen.value = false;
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
    MyBoxShadows shadows = MyBoxShadows();

    final List<Map<String, dynamic>> pageConfigs = [
      {
        'title': 'Home',
        'trailing': null,
        'onTrailingPressed': null,
        'page': HomePage(user: widget.user),
      },
      {
        'title': 'Tanks',
        'trailing': const MyIcon(icon: Icons.add),
        'onTrailingPressed': () async {
                        final bool tankAdded = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddTankPage(user: widget.user,)));

                          if (tankAdded == true) {
                            _tankListKey.currentState?.updateTanks();
                          }
                      },
        'page': TankListPage(key: _tankListKey, user: widget.user),
      },
      {
        'title': 'Page 2',
        'trailing': null,
        'onTrailingPressed': null,
        'page': Page2(user: widget.user),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            MyDrawer(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
            GestureDetector(
              onTap: () => _isDrawerOpen.value ? _closeDrawer() : null,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isDrawerOpen,
                builder: (context, isDrawerOpen, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 275),
                    transform: Matrix4.translationValues(_xOffset, _yOffset, 0)
                      ..scale(_scaleFactor),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: _isDrawerOpen.value
                          ? BorderRadius.circular(12)
                          : BorderRadius.circular(0),
                      boxShadow: _isDrawerOpen.value
                          ? [
                              shadows.darkShadow(context),
                              shadows.lightShadow(context),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        buildAppBar(
                          pageConfigs[_selectedIndex]['title'],
                          leading: const MyIcon(icon: Icons.menu),
                          onLeadingPressed: _openDrawer,
                          isLeadingPressed: _isDrawerOpen.value,
                          trailing: pageConfigs[_selectedIndex]['trailing'],
                          onTrailingPressed: pageConfigs[_selectedIndex]['onTrailingPressed'],
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            children: pageConfigs.map((config) => config['page'] as Widget).toList(),
                          ),
                        ),
                        MyNavBar(
                          selectedIndex: _selectedIndex,
                          onItemTapped: _onItemTapped,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
