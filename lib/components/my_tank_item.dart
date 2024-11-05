import 'package:flutter/material.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_image.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/tank_detail_page.dart';

// ignore: must_be_immutable
class MyTankItem extends StatefulWidget {
  Tank tank;

  MyTankItem({
    super.key,
    required this.tank,
  });

  @override
  State<MyTankItem> createState() => _MyTankItemState();
}

class _MyTankItemState extends State<MyTankItem> {
  @override
  Widget build(BuildContext context) {
    String tankInfo;

  String? waterInfo = (widget.tank.waterType != null && widget.tank.waterType!.isNotEmpty) 
      ? widget.tank.waterType 
      : null;

  String? volumeInfo = (widget.tank.width != 0 && widget.tank.depth != 0 && widget.tank.height != 0)
      ? '${((widget.tank.width! * widget.tank.depth! * widget.tank.height!) / 1000).toStringAsFixed(0)}L' 
      : null;

  if (waterInfo != null && volumeInfo != null) {
    tankInfo = '$waterInfo, $volumeInfo';
  } else if (waterInfo != null) {
    tankInfo = waterInfo;
  } else if (volumeInfo != null) {
   tankInfo = 'Unknown, $volumeInfo';
  } else {
    tankInfo = 'Unknown';
  }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: MyButton(
          child: Row(
            children: [
              MyImageLoader(tank: widget.tank, size: 100),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric( 
                    horizontal: 20
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: widget.tank.name.toString(),
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
                        text: convertFromIso8601String(widget.tank.setupAt.toString()),
                        letterSpacing: 2.0,
                        size: 12,
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
          onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TankDetailPage(tank: widget.tank),
                ),
              );
            },
        )
      );
  }
}