import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tankyou/components/my_loading_indicator.dart';
import 'package:tankyou/components/my_tank_item.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/services/tank_service.dart';

class MyTankList extends StatefulWidget {
  final User user;

  const MyTankList({
    super.key, 
    required this.user
  });

  @override
  State<MyTankList> createState() => _MyTankListState();
}

class _MyTankListState extends State<MyTankList> {
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

    return ListView.builder(
      itemCount: _tanks.length,
      itemBuilder: (context, index) {
        var tank = _tanks[index];
        return MyTankItem(user: widget.user, tank: tank);
      },
    );
  }
}
