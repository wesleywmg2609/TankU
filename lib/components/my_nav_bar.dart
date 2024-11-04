import 'package:flutter/material.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_overlay_icon.dart';

class MyNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MyButton(
            onPressed: () => widget.onItemTapped(0),
            resetAfterPress: false,
            isPressed: widget.selectedIndex == 0,
            child: const MyIcon(icon: Icons.home)
          ),
          MyButton(
            onPressed: () => widget.onItemTapped(1),
            resetAfterPress: false,
            isPressed: widget.selectedIndex == 1,
            child: const MyOverlayIcon(icon: Icons.call_to_action, svgFilepath: 'assets/fish.svg', padding: 3)
          ),
          MyButton(
            onPressed: () => widget.onItemTapped(2),
            resetAfterPress: false,
            isPressed: widget.selectedIndex == 2,
            child: const MyIcon(icon: Icons.add_rounded)
          ),
          MyButton(
            onPressed: () => widget.onItemTapped(3),
            resetAfterPress: false,
            isPressed: widget.selectedIndex == 3,
            child: const MyIcon(icon: Icons.group)
          ),
          MyButton( 
            onPressed: () => widget.onItemTapped(4),
            resetAfterPress: false,
            isPressed: widget.selectedIndex == 4,
            child: const MyIcon(icon: Icons.settings)
          ),
        ],
      ),
    );
  }
}
