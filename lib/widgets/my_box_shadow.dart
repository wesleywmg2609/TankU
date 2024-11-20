import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class MyBoxShadows {
  final Offset distanceDark = const Offset(2, 2);
  final Offset distanceLight = const Offset(0, 0);
  final Offset distanceDarkPressed = const Offset(2, 2);
  final Offset distanceLightPressed = const Offset(-1, -1);
  final double blur = 3;
  final double blurPressed = 5;
  final double spread = 1;

  BoxShadow _createShadow(BuildContext context, Color color, Offset offset, double blurRadius, double spreadRadius, bool inset) {
    return BoxShadow(
      color: color,
      offset: offset,
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      inset: inset,
    );
  }

  BoxShadow darkShadow(BuildContext context) {
    return _createShadow(
      context,
      Theme.of(context).shadowColor,
      distanceDark,
      blur,
      spread,
      false,
    );
  }

  BoxShadow lightShadow(BuildContext context) {
    return _createShadow(
      context,
      Theme.of(context).highlightColor,
      distanceLight,
      blur,
      spread,
      false,
    );
  }

  BoxShadow darkShadowPressed(BuildContext context) {
    return _createShadow(
      context,
      Theme.of(context).shadowColor,
      distanceDarkPressed,
      blurPressed,
      spread,
      true,
    );
  }

  BoxShadow lightShadowPressed(BuildContext context) {
    return _createShadow(
      context,
      Theme.of(context).highlightColor,
      distanceLightPressed,
      blurPressed,
      spread,
      true,
    );
  }

  List<BoxShadow> unpressedShadows(BuildContext context) {
    return [
      darkShadow(context),
      lightShadow(context),
    ];
  }

  List<BoxShadow> pressedShadows(BuildContext context) {
    return [
      darkShadowPressed(context),
      lightShadowPressed(context),
    ];
  }
}
