import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/widgets/my_theme.dart';

class MyDateField extends StatefulWidget {
  final TextEditingController controller;
  final Widget icon;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime)? onDateSelected;

  const MyDateField({
    super.key,
    required this.controller,
    required this.icon,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSelected,
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
    widget.controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate:  widget.lastDate,
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
        widget.controller.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate);
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(_selectedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: reusableBoxDecoration(context: context),
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
