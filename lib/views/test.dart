import 'package:flutter/material.dart';
import 'package:tankyou/components/my_button.dart';
import 'package:tankyou/components/my_icon.dart';
import 'package:tankyou/helper/functions.dart';

class testpage extends StatefulWidget {
  const testpage({super.key});

  @override
  State<testpage> createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyButton(child: MyIcon(icon: Icons.menu), onPressed: () => showLoadingDialog),);
  }
}