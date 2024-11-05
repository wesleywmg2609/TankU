import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

void logger(String message) {
  final logger = Logger();

  logger.d('Logger: $message');
}

String convertToIso8601String(String datetime) {
  DateTime convertedDatetime = DateFormat("MM/dd/yyyy").parse(datetime);
  return convertedDatetime.toIso8601String();
}

String convertFromIso8601String(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  return DateFormat('MMM d, yyyy').format(dateTime);
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
            Navigator.pop(context, true);
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

void toggleConfetti(ConfettiController confettiController,
    ValueNotifier<bool> isConfettiPlaying) {
  if (isConfettiPlaying.value) {
    confettiController.stop();
    isConfettiPlaying.value = false;
  } else {
    confettiController.play();
    isConfettiPlaying.value = true;
  }
}
