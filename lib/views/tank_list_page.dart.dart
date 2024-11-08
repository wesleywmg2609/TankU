import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<Tank> _tanks = [];
  bool _isLoading = true;
  late TankService _tankService;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _fetchTanks();

    // FirebaseDatabase.instance.ref('tanks/${widget.user.uid}').onValue.listen((event) {
    //   _fetchTanks();
    // });
  }

  Future<void> _fetchTanks() async {
    final fetchedTanks = await _tankService.getAllTanks();
    fetchedTanks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (mounted) {
      setState(() {
      _tanks = fetchedTanks;
      _isLoading = false;
    });
    }
    
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
              child: MyTankList(listItems: _tanks, user: widget.user),
            ),
        ],
      )),
    );
  }
}
