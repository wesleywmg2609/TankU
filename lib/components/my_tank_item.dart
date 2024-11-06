import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_image_loader.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/tank_info_page.dart';

// ignore: must_be_immutable
class MyTankItem extends StatefulWidget {
  final User user;
  final DatabaseReference tankRef;

  const MyTankItem({
    super.key,
    required this.user,
    required this.tankRef,
  });

  @override
  State<MyTankItem> createState() => _MyTankItemState();
}

class _MyTankItemState extends State<MyTankItem> {
  Tank? _tank;

  @override
  void initState() {
    super.initState();
    updateTank();
  }

  void updateTank() async {
    getTankById(widget.tankRef, widget.user.uid).then((fetchedTank) {
      setState(() {
        _tank = fetchedTank;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String tankInfo;

    String? waterInfo = _tank?.waterType ?? 'Unknown';

    String? volumeInfo = (_tank != null &&
            _tank!.width != null &&
            _tank!.depth != null &&
            _tank!.height != null &&
            _tank!.width! != 0 &&
            _tank!.depth! != 0 &&
            _tank!.height! != 0)
        ? '${((_tank!.width! * _tank!.depth! * _tank!.height!) / 1000).toStringAsFixed(0)}L'
        : null;

    if (volumeInfo != null) {
      tankInfo = '$waterInfo, $volumeInfo';
    } else if (volumeInfo != null) {
      tankInfo = 'Unknown, $volumeInfo';
    } else {
      tankInfo = waterInfo;
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: MyButton(
          child: Row(
            children: [
              MyImageLoader(url: _tank?.imageUrl, size: 100),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: _tank?.name.toString() ??
                          '???', // Provide a fallback value if _tank is null
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
                      text: _tank?.setupAt != null
                          ? convertFromIso8601String(_tank!.setupAt.toString())
                          : '???', // Provide a fallback text if `setupAt` is null
                      letterSpacing: 2.0,
                      size: 12,
                    )
                  ],
                ),
              )),
            ],
          ),
          onPressed: () async {
            final bool tankUpdated = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TankInfoPage(
                          user: widget.user,
                          tankRef: widget.tankRef,
                        )));

            if (tankUpdated == true) {
              updateTank();
            }
          },
        ));
  }
}
