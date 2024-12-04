import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  final IconData icon;
  final String labelText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MyDropdown({
    super.key,
    required this.icon,
    required this.labelText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedValue,
      hint: Text(
        widget.labelText,
        style: TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.onSurface),
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
