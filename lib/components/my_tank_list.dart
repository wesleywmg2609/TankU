import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tankyou/components/my_tank_item.dart';
import 'package:tankyou/models/tank.dart';

class MyTankList extends StatefulWidget {
  final User user;
  final List<Tank> listItems;

  const MyTankList({
    super.key, 
    required this.listItems, 
    required this.user
  });

  @override
  State<MyTankList> createState() => _MyTankListState();
}

class _MyTankListState extends State<MyTankList> {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: widget.listItems.length,
        itemBuilder: (context, index) {
          var tank = widget.listItems[index];

          return MyTankItem(user: widget.user, tank: tank);
        });
  }
}
