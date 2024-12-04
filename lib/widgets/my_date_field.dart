import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tanku/widgets/my_theme.dart';

class MyDateField extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
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
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        final ThemeData modifiedLightMode = lightMode.copyWith(
          colorScheme: lightMode.colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.onSurface,
          ),
        );
        return Theme(
          data: Theme.of(context).brightness == Brightness.light
              ? modifiedLightMode
              : darkMode,
          child: child ?? Container(),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(_selectedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        onTap: () => _selectDate(context),
        readOnly: true,
        style: TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          prefixIcon:
              Icon(widget.icon, color: Theme.of(context).colorScheme.onSurface),
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
        ));
  }
}
