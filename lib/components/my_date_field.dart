import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:intl/intl.dart';
import 'package:tankyou/components/my_box_shadow.dart';
import 'package:tankyou/components/my_theme.dart';

class MyDateField extends StatefulWidget {
  final TextEditingController controller;
  final Widget icon;
  final DateTime initialDate;
  const MyDateField({
    super.key,
    required this.controller,
    required this.icon,
    required this.initialDate,
  });

  @override
  _MyDateFieldState createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    widget.controller.text = DateFormat.yMd().format(_selectedDate); 
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.light
              ? lightMode
              : darkMode,
          child: child ?? Container(),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat.yMd().format(_selectedDate);
      });
    } else {
      widget.controller.text = DateFormat.yMd().format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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
            onTap: () => _selectDate(context),
            readOnly: true,
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
              contentPadding: const EdgeInsets.only(top: 15),
            )),
      ),
    );
  }
}
