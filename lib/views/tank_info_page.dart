import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_image_loader.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/edit_tank_page.dart';

// ignore: must_be_immutable
class TankInfoPage extends StatefulWidget {
  final User user;
  final DatabaseReference tankRef;

  const TankInfoPage({
    super.key,
    required this.user,
    required this.tankRef,
  });

  @override
  State<TankInfoPage> createState() => _TankInfoPageState();
}

class _TankInfoPageState extends State<TankInfoPage> {
  Tank? tank;

  @override
  void initState() {
    super.initState();
    updateTank();
  }

  void updateTank() async {
    getTankById(widget.tankRef, widget.user.uid).then((fetchedTank) {
      setState(() {
        tank = fetchedTank;
      });
    });
  }

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
            subtitle: tank?.name.toString(),
            trailing: const MyIcon(icon: Icons.edit),
            onTrailingPressed: () async {
              final bool tankUpdated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTankPage(
                            user: widget.user,
                            tankRef: widget.tankRef,
                          )));

              if (tankUpdated == true) {
                updateTank();
              }
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
                  MyImageLoader(url: tank?.imageUrl, size: 150),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(),
                  ))
                ],
              )),
            ),
          ),
        ],
      )),
    );
  }
}
