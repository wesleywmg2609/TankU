import 'package:flutter/material.dart';
import 'package:tankyou/auth/auth.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_overlay_icon.dart';

class MyDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const MyDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

Widget _buildListTile(String title, Widget icon, int index) {
  bool isSelected = widget.selectedIndex == index;
  return GestureDetector(
    onTap: () => widget.onItemTapped(index),
    child: Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSelected ? 5 : 0,
          height: 50,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        Expanded(
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 2.0,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'SFPro',
              ),
            ),
            leading: icon,
          ),
        ),
      ],
    ),
  );
}


   Widget _buildLogoutTile() {
    return GestureDetector(
      onTap: () {
        signOut(context);
      },
      child: const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(width: 5),
            Expanded(
              child: ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    letterSpacing: 2.0,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFPro',
                  ),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          _buildListTile('Home', const MyIcon(icon: Icons.home), 0),
          _buildListTile('Tanks', const MyOverlayIcon(icon: Icons.call_to_action, svgFilepath: 'assets/fish.svg', padding: 3), 1),
          _buildListTile('Page 2', const MyIcon(icon: Icons.add), 2),
          _buildListTile('Page 3', const MyIcon(icon: Icons.group), 3),
          _buildListTile('Page 4', const MyIcon(icon: Icons.settings), 4),
          const Spacer(),
          _buildLogoutTile(),
        ],
      ),
    );
  }
}
