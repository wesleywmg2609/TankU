import 'package:flutter/material.dart';
import 'package:tankyou/components/my_app_bar.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/components/my_image_loader.dart';
import 'package:tankyou/components/my_text.dart';
import 'package:tankyou/database/database.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';
import 'package:tankyou/views/edit_tank_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tankyou/components/my_cube.dart';

// ignore: must_be_immutable
class TankInfoPage extends StatefulWidget {
  final User user;
  final DatabaseReference tankRef;

  const TankInfoPage({
    super.key,
    required this.user,
    required this.tankRef,
  });

  @override
  State<TankInfoPage> createState() => _TankInfoPageState();
}

class _TankInfoPageState extends State<TankInfoPage> {
  Tank? _tank;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.tankRef.onValue.listen((event) {
      updateTank();
    });
    updateTank();
  }

  @override
  void dispose() {
    widget.tankRef.onValue.drain();
    super.dispose();
  }

  Future<void> updateTank() async {
    getTankById(widget.tankRef, widget.user.uid).then((fetchedTank) {
      setState(() {
        _tank = fetchedTank;
      });
    });
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  String _getDaysSinceSetup(String setupAtIso8601) {
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

  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Column(
        children: [
          MyAppBar(
            title: 'Tank Info',
            subtitle: _tank?.name.toString(),
            trailing: const MyIcon(icon: Icons.edit),
            onTrailingPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTankPage(
                            user: widget.user,
                            tankRef: widget.tankRef,
                          )));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  shadows.darkShadow(context),
                  shadows.lightShadow(context),
                ],
              ),
              child: Center(
                  child: Column(
                children: [
                  Row(
                    children: [
                      MyImageLoader(url: _tank?.imageUrl, size: 150),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _tank?.waterType?.isNotEmpty ?? false
                                ? MyText(
                                    text: _tank!
                                        .waterType!,
                                    letterSpacing: 2.0,
                                    size: 12,
                                  )
                                : const SizedBox
                                    .shrink(),
                            MyText(
                              text: _tank?.setupAt != null
                                  ? _getDaysSinceSetup(_tank!.setupAt)
                                  : '? days',
                              letterSpacing: 2.0,
                              isBold: true,
                              size: 20,
                            ),
                            MyText(
                              text: _tank?.setupAt != null
                                  ? '(${convertFromIso8601String(_tank!.setupAt.toString())})'
                                  : '(???)',
                              letterSpacing: 2.0,
                              size: 12,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    alignment: Alignment.topCenter,
                    child: _isExpanded
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                const MyText(
                                  text: 'Volume',
                                  letterSpacing: 2.0,
                                  isBold: true,
                                  size: 16,
                                ),
                                const SizedBox(height: 16),
                                MyCube(
                                  width: _tank?.width ?? 0,
                                  depth: _tank?.depth ?? 0,
                                  height: _tank?.height ?? 0,
                                ),
                                const SizedBox(height: 16),
                                const MyText(
                                  text:
                                      'More detailed information goes here. This content is shown when the box is expanded.',
                                  letterSpacing: 2.0,
                                  size: 12,
                                ),
                                const SizedBox(height: 16),
                                const MyText(
                                  text: 'Equipment',
                                  letterSpacing: 2.0,
                                  isBold: true,
                                  size: 16,
                                ),
                                const SizedBox(height: 16),
                                const MyText(
                                  text:
                                      'More detailed information goes here. This content is shown when the box is expanded.',
                                  letterSpacing: 2.0,
                                  size: 12,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(height: 16),
                  ),
                  GestureDetector(
                    onTap: _toggleExpand,
                    child: _isExpanded
                        ? const MyIcon(icon: Icons.keyboard_arrow_up)
                        : const MyIcon(icon: Icons.keyboard_arrow_down),
                  )
                ],
              )),
            ),
          ),
        ],
      )),
    );
  }
}
