import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:tanku/widgets/my_box_shadow.dart';

MyBoxShadows shadows = MyBoxShadows();

BoxDecoration reusableBoxDecoration({
  required BuildContext context,
  bool isPressed = false,
  Color? color,
  double? borderRadius,
}) {
  return BoxDecoration(
    color: color ?? Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(borderRadius ?? 12),
    boxShadow: isPressed
        ? shadows.pressedShadows(context)
        : shadows.unpressedShadows(context),
  );
}

void logger(String message) {
  final logger = Logger();

  logger.d('Logger: $message');
}

String convertToIso8601String(String datetime) {
  DateTime convertedDatetime = DateFormat("dd/MM/yyyy").parse(datetime);
  return convertedDatetime.toIso8601String();
}

DateTime convertFromIso8601String(String isoString) {
  try {
    return DateTime.parse(isoString);
  } catch (e) {
    print('Error parsing date: $e');
    return DateTime(0);
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
    builder: (context) => Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onSurface),
      ),
    ),
  );
}

String getDaysSinceSetup(String setupAtIso8601) {
  final setupAt = DateTime.parse(setupAtIso8601);

  final currentDate = DateTime.now();
  final currentDateWithoutTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day);

  final difference = currentDateWithoutTime
      .difference(DateTime(setupAt.year, setupAt.month, setupAt.day));

  if (difference.inDays >= 0) {
    return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''}';
  }

  return '? days';
}

void displayMessageToUser(String message, BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Dismiss",
    barrierColor: Theme.of(context).colorScheme.surface,
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.0,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Press anywhere to exit',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'SFPro',
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
