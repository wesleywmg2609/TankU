import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tanku/widgets/my_button2.dart';

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
            child: MyButton2(
              icon: Ionicons.fish_outline, 
              iconPressed: Ionicons.fish,
              labelText: 'Tanks',
              isPressed: widget.selectedIndex == 0,
              onTap: () => widget.onItemTapped(0)
              ),
          ),
          Expanded(
            child: MyButton2(
              icon: Ionicons.calendar_number_outline, 
              iconPressed: Ionicons.calendar_number,
              labelText: 'Calendar',
              isPressed: widget.selectedIndex == 1,
              onTap: () => widget.onItemTapped(1)
              ),
          ),
          Expanded(
            child: MyButton2(
              icon: Ionicons.people_outline, 
              iconPressed: Ionicons.people,
              labelText: 'Community',
              isPressed: widget.selectedIndex == 2,
              onTap: () => widget.onItemTapped(2)
              ),
          ),
          Expanded(
            child: MyButton2(
              icon: Ionicons.grid_outline, 
              iconPressed: Ionicons.grid,
              labelText: 'More',
              isPressed: widget.selectedIndex == 3,
              onTap: () => widget.onItemTapped(3)
              ),
          ),
        ],
      ),
    );
  }
}
