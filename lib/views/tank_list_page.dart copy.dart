import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/views/add_tank_page.dart';
import 'package:tanku/views/my_tank_info2.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/widgets/my_app_bar2.dart';

// ignore: must_be_immutable
class TankListPage2 extends StatefulWidget {
  final User user;

  const TankListPage2({
    super.key,
    required this.user,
  });

  @override
  TankListPage2State createState() => TankListPage2State();
}

class TankListPage2State extends State<TankListPage2> {
  late TankService _tankService;
  List<Tank?> _tanks = [];

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _tankService.listenToAllTanksUpdates();

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tanks = _tankService.tanks;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tankService.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
          child: Column(
        children: [
          MyAppBar2(
              title: 'Tanks',
              subtitle: 'Good Morning!',
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTankPage(user: widget.user),
                    ),
                  );
                });
              }),
          Expanded(
            child: Container(
              //color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount: _tanks.length,
                  itemBuilder: (context, index) {
                    var tank = _tanks[index];
                    return _buildTankItem(tank!);
                  },
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildTankItem(Tank tank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TankInfoPage2(user: widget.user, tank: tank),
              ),
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xff282a29),
                  child: tank.imageUrl != null && tank.imageUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            tank.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Ionicons.fish),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(tank.name,
                              style: const TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff282a29))),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Text('Freshwater',
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    fontSize: 10,
                                    color: Color(0xffffffff))),
                          ),
                        ],
                      ),
                      Text(
                          DateFormat('MMMM d, yyyy')
                              .format(convertFromIso8601String(tank.setupAt)),
                          style: const TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 14,
                              color: Color(0xff282a29))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
