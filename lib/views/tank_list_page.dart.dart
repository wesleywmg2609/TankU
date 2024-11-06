import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_tank_list.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/models/tank.dart';

// ignore: must_be_immutable
class TankListPage extends StatefulWidget {
  final User user;

  const TankListPage({
    super.key,
    required this.user,
  });

  @override
  TankListPageState createState() => TankListPageState();
}

class TankListPageState extends State<TankListPage> {
  List<Tank> tanks = [];

  @override
  void initState() {
    super.initState();
    updateTanks();
  }

  void updateTanks() {
    getAllTanks(widget.user.uid).then((fetchedTanks) {
      setState(() {
        tanks = fetchedTanks;
        tanks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
              children: [
                Expanded(
                  child: MyTankList(listItems: tanks, user: widget.user),
                ),
              ],
            )
      ),
    );
  }
}