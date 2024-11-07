import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_loading_indicator.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    updateTanks();
  }

  void updateTanks() {
    setState(() {
      _isLoading = true;
    });

    getAllTanks(widget.user.uid).then((fetchedTanks) {
      fetchedTanks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        tanks = fetchedTanks;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      if (_isLoading) {
        return const MyLoadingIndicator();
      }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Column(
        children: [
            Expanded(
              child: MyTankList(listItems: tanks, user: widget.user),
            ),
        ],
      )),
    );
  }
}
