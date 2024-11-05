import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tankyou/components/my_box_shadow.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final Widget icon;
  final String labelText;
  final bool isPassword;
  final bool isNumeric;

  const MyTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
    this.isPassword = false,
    this.isNumeric = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isFocused
            ? [
                shadows.darkShadowPressed(context),
                shadows.lightShadowPressed(context),
              ]
            : [
                shadows.darkShadow(context),
                shadows.lightShadow(context),
              ],
      ),
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.onSurface,
          selectionColor: Theme.of(context).colorScheme.primary,
          selectionHandleColor: Theme.of(context).colorScheme.onSurface,
        ),
        child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            focusNode: _focusNode,
            keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters: widget.isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
            style: const TextStyle(
              letterSpacing: 2.0,
              fontFamily: 'SFPro',
              fontSize: 12,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: widget.icon,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: const EdgeInsets.only(top: 16),
              labelText: !_isFocused && widget.controller.text.isEmpty
                  ? widget.labelText
                  : null,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 2.0,
                fontFamily: 'SFPro',
                fontSize: 12,
              ),
            )),
      ),
    );
  }
}
