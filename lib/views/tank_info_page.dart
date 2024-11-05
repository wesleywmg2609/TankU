import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_image.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/edit_tank_page.dart';

class TankInfoPage extends StatefulWidget {
  final User user;
  final Tank tank;

  TankInfoPage({
    super.key,
    required this.user,
    required this.tank,
  });

  @override
  State<TankInfoPage> createState() => _TankInfoPageState();
}

class _TankInfoPageState extends State<TankInfoPage> {
  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              title: 'Tank Info',
              subtitle: widget.tank.name.toString(),
              trailing: const MyIcon(icon: Icons.edit),
              onTrailingPressed: ()  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditTankPage(user: widget.user, tank: widget.tank,)));
                      },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                          shadows.darkShadow(context),
                          shadows.lightShadow(context),
                        ],
                ),
                child: Center(
                  child: Row(
                    children: [
                      MyImageLoader(url: widget.tank.imageUrl, size: 150),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(),
                          )
                      )
                    ],
                  )
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}