import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_overlay_icon.dart';
import 'package:tankyou/components/my_tank_list.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/components/my_text_field.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/tank_detail_page.dart';

Widget buildTextField(
  TextEditingController controller,
  Widget child,
  String text, 
  {
    bool isPassword = false,
    bool isNumeric = false,
  }
) {
  return MyTextField(
    controller: controller,
    labelText: text,
    isPassword: isPassword,
    isNumeric: isNumeric,
    child: child,
  );
}

Widget buildHyperlink(
  BuildContext context, 
  String text, 
  VoidCallback onTap
) {
  return GestureDetector(
    onTap: onTap,
    child: Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        letterSpacing: 1.0,
        fontFamily: 'SFPro',
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
    ),
  );
}

Widget buildTankList(
  List<Tank> listTanks,
  User user,
) {
  return MyTankList(listTanks, user);
}

Widget buildTankItem(
  BuildContext context,
  Tank tank,
) {
  String tankInfo;

  String? waterInfo = (tank.waterType != null && tank.waterType!.isNotEmpty) 
      ? tank.waterType 
      : null;

  String? volumeInfo = (tank.width != 0 && tank.depth != 0 && tank.height != 0)
      ? '${((tank.width! * tank.depth! * tank.height!) / 1000).toStringAsFixed(0)}L' 
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
              loadImage(tank, 100),
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
                        text: tank.name.toString(),
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
                )
              ),
            ],
          ),
          onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TankDetailPage(tank: tank),
                ),
              );
            },
        )
      );
}

Widget buildAppBar(
  String title, 
  {
    String? subtitle,
    Widget? leading,
    Function()? onLeadingPressed,
    bool? isLeadingPressed,
    Widget? trailing,
    Function()? onTrailingPressed,
    bool? isTrailingPressed,
  }
) {
  return MyAppBar(
    leading: leading,
    leadingOnPressed: onLeadingPressed,
    isLeadingPressed: isLeadingPressed,
    trailing: trailing,
    trailingOnPressed: onTrailingPressed,
    isTrailingPressed: isTrailingPressed,
    title: title,
    subtitle: subtitle,
  );
}

Widget loadImage(
  Tank tank, 
  double size
) {
  return SizedBox(
    width: size,
    height: size,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        (tank.imageUrl != null && tank.imageUrl!.isNotEmpty)
            ? tank.imageUrl.toString()
            : '',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const MyOverlayIcon(
            icon:  Icons.call_to_action, svgFilepath: 'assets/fish.svg', iconSize: 48, svgSize: 20, padding: 3),
      ),
    ),
  );
}

ConfettiWidget createConfetti(ConfettiController confettiController) {
  return ConfettiWidget(
    confettiController: confettiController,
    blastDirection: pi / 2,
    gravity: 0.1,
    emissionFrequency: 1,
    numberOfParticles: 2,
    shouldLoop: true,
  );
}
