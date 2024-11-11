import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_app_bar.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_image_loader.dart';
import 'package:tanku/components/my_text.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/views/edit_tank_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:tanku/components/my_cube.dart';

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
  MyBoxShadows shadows = MyBoxShadows();
  late TankService _tankService;
  Tank? _tank;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _tankService.listenToTankUpdates(widget.tankRef);

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tank = _tankService.tank;
        });
      }
    });
  }

  @override
  void dispose() {
    _tankService.removeListener(() {});
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  _buildAppBar() {
    return MyAppBar(
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
    );
  }

  _buildUpperPart() {
    return Padding(
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
        child: Column(
          children: [
            Row(
              children: [
                MyImageLoader(url: _tank?.imageUrl, size: 150),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_tank?.waterType?.isNotEmpty ?? false)
                        MyText(
                          text: _tank!.waterType!,
                          letterSpacing: 2.0,
                          size: 12,
                        ),
                      MyText(
                        text: _tank?.setupAt != null
                            ? getDaysSinceSetup(_tank!.setupAt)
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
                ),
              ],
            ),
            _buildHiddenPart(),
            GestureDetector(
              onTap: _toggleExpand,
              child: MyIcon(
                icon: _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenPart() {
  return AnimatedSize(
    duration: const Duration(milliseconds: 500),
    curve: Curves.fastEaseInToSlowEaseOut,
    alignment: Alignment.topCenter,
    child: _isExpanded
        ? Column(
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Volume'),
            MyCube(
              width: _tank?.width ?? 0,
              depth: _tank?.depth ?? 0,
              height: _tank?.height ?? 0,
            ),
            const SizedBox(height: 16),
            _buildSectionDescription(
                'More detailed information goes here. This content is shown when the box is expanded.'),
            _buildSectionTitle('Equipment'),
            _buildSectionDescription(
                'More detailed information goes here. This content is shown when the box is expanded.'),
          ],
        )
        : const SizedBox(height: 16),
  );
}

_buildSectionTitle(String title) {
  return Column(
    children: [
      MyText(
        text: title,
        letterSpacing: 2.0,
        isBold: true,
        size: 16,
      ),
      const SizedBox(height: 16),
    ],
  );
}

_buildSectionDescription(String description) {
  return Column(
    children: [
      MyText(
        text: description,
        letterSpacing: 2.0,
        size: 12,
      ),
      const SizedBox(height: 16),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
          child: Column(
        children: [
          _buildAppBar(),
          _buildUpperPart(),
        ],
      )),
    );
  }
}
