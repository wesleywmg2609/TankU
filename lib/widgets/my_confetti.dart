import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyConfetti extends StatelessWidget {
  ConfettiController controller;
  
  MyConfetti({
    super.key,
    required this.controller
    });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
    confettiController: controller,
    blastDirection: pi / 2,
    gravity: 0.1,
    emissionFrequency: 1,
    numberOfParticles: 2,
    shouldLoop: true,
  );
  }
}