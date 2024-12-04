import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
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
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      style: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 12,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: const Color(0xff282a29)),
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 2.5,
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true, 
      ),
    );
  }
}
