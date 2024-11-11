import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_loading_indicator.dart';
import 'package:tanku/components/my_tank_item.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/services/image_service.dart';
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
  late ImageService _imageService;
  List<Tank?> _tanks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _imageService = Provider.of<ImageService>(context, listen: false);
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
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                itemCount: _tanks.length,
                itemBuilder: (context, index) {
                  var tank = _tanks[index];
                  return Slidable(
                    key: ValueKey(tank?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          child: MyButton(child: const MyIcon(icon: Icons.delete, color: Colors.red,), onPressed:() {
                            if (tank != null) {
                              if (tank.imageUrl != null && tank.imageUrl!.isNotEmpty) {
                                _imageService.deleteImage(tank.imageUrl!);
                              }
                              _tankService.deleteTank(tank.id);
                            }
                            
                          }),
                        ))
                      ]
                      ),
                    child: MyTankItem(user: widget.user, tank: tank));
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
