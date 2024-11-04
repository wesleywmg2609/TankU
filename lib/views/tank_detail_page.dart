import 'package:flutter/material.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/helper/widgets.dart';
import 'package:tankyou/models/tank.dart';

class TankDetailPage extends StatefulWidget {
  final Tank tank;

  const TankDetailPage({
    super.key,
    required this.tank,
  });

  @override
  State<TankDetailPage> createState() => _TankDetailPageState();
}

class _TankDetailPageState extends State<TankDetailPage> {
  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(
              'Tank Info',
              subtitle: widget.tank.name.toString(),
              trailing: const MyIcon(icon: Icons.edit),
              onTrailingPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                          shadows.darkShadow(context),
                          shadows.lightShadow(context),
                        ],
                ),
                child: Center(
                  child: Row(
                    children: [
                      loadImage(widget.tank, 150),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(),
                          )
                      )
                    ],
                  )
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}