import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MyNavBar2 extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyNavBar2({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<MyNavBar2> createState() => _MyNavBar2State();
}

class _MyNavBar2State extends State<MyNavBar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemTapped(0),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        widget.selectedIndex == 0
                            ? Ionicons.fish
                            : Ionicons.fish_outline,
                        key:
                            ValueKey(widget.selectedIndex == 0), // Ensure rebuild
                        color: const Color(0xff282a29),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tanks',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff282a29)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemTapped(1),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        widget.selectedIndex == 1
                            ? Ionicons.calendar_number
                            : Ionicons.calendar_number_outline,
                        key:
                            ValueKey(widget.selectedIndex == 1), // Ensure rebuild
                        color: const Color(0xff282a29),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Calendar',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff282a29)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemTapped(2),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        widget.selectedIndex == 2
                            ? Ionicons.people
                            : Ionicons.people_outline,
                        key:
                            ValueKey(widget.selectedIndex == 2), // Ensure rebuild
                        color: const Color(0xff282a29),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Community',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff282a29)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onItemTapped(3),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        widget.selectedIndex == 3
                            ? Ionicons.grid
                            : Ionicons.grid_outline,
                        key: ValueKey(widget.selectedIndex == 3),
                        color: const Color(0xff282a29),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'More',
                      style: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff282a29)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
