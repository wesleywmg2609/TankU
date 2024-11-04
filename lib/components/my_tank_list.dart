import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tankyou/helper/widgets.dart';
import 'package:tankyou/models/tank.dart';

class MyTankList extends StatefulWidget {
  final List<Tank> listItems;
  final User user;

  MyTankList(this.listItems, this.user);

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

          return buildTankItem(context, tank);
        });
  }
}
