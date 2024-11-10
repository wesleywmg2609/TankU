import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_loading_indicator.dart';
import 'package:tanku/components/my_tank_item.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/services/tank_service.dart';

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
  late TankService _tankService;
  List<Tank?> _tanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _tankService.listenToAllTanksUpdates();

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tanks = _tankService.tanks;
          _isLoading = _tankService.isLoading;
        });
      }
    });
  }

  @override
  void dispose() {
    _tankService.removeListener(() {});
    super.dispose();
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
            child: ListView.builder(
              itemCount: _tanks.length,
              itemBuilder: (context, index) {
                var tank = _tanks[index];
                return MyTankItem(user: widget.user, tank: tank);
              },
            ),
          ),
        ],
      )),
    );
  }
}
