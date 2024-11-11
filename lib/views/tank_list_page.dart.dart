import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_image_loader.dart';
import 'package:tanku/components/my_loading_indicator.dart';
import 'package:tanku/components/my_text.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/services/image_service.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/views/tank_info_page.dart';

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

  _buildLoadingIndicator() {
    if (_isLoading) {
      return const MyLoadingIndicator();
    }
  }

  _buildTankList() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        child: ListView.builder(
          itemCount: _tanks.length,
          itemBuilder: (context, index) {
            var tank = _tanks[index];
            return Slidable(
                key: ValueKey(tank?.id),
                endActionPane:
                    ActionPane(
                      motion: const ScrollMotion(), 
                      children: [
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          child: _buildDeleteButton(tank),
                        )
                      )
                    ]
                  ),
                child: _buildTankItem(tank));
          },
        ),
      ),
    );
  }

  _buildTankItem(tank) {
    final waterInfo =
        tank.waterType?.isNotEmpty == true ? tank.waterType : null;
    final volumeInfo = (tank.width != null &&
            tank.depth != null &&
            tank.height != null &&
            tank.width! > 0 &&
            tank.depth! > 0 &&
            tank.height! > 0)
        ? '${((tank.width! * tank.depth! * tank.height!) / 1000).toStringAsFixed(0)}L'
        : null;

    final tankInfo = [
      if (waterInfo != null) waterInfo,
      if (volumeInfo != null) volumeInfo
    ].join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: MyButton(
        child: Row(
          children: [
            MyImageLoader(url: tank.imageUrl, size: 100),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: tank.name,
                      isBold: true,
                      letterSpacing: 2.0,
                      size: 16,
                    ),
                    if (tankInfo.isNotEmpty)
                      MyText(
                        text: tankInfo,
                        letterSpacing: 2.0,
                        size: 12,
                      ),
                    MyText(
                      text: convertFromIso8601String(tank.setupAt.toString()),
                      letterSpacing: 2.0,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TankInfoPage(
                user: widget.user,
                tankRef: tank.id,
              ),
            ),
          );
        },
      ),
    );
  }

  _buildDeleteButton(tank) {
    return MyButton(
        child: const MyIcon(
          icon: Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          if (tank != null) {
            if (tank.imageUrl != null && tank.imageUrl!.isNotEmpty) {
              _imageService.deleteImage(tank.imageUrl!);
            }
            _tankService.deleteTank(tank.id);
          }
        }
      );
  }

  @override
  Widget build(BuildContext context) {

    _buildLoadingIndicator();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: _buildTankList()),
    );
  }
}
