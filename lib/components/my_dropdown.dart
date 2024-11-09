import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:tanku/components/my_box_shadow.dart';

class MyDropdown extends StatefulWidget {
  final Widget icon;
  final String labelText;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const MyDropdown({
    Key? key,
    required this.icon,
    required this.labelText,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {

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
      child: DropdownButtonFormField<String>(
        value: widget.selectedValue,
        hint: Text(
          widget.labelText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 2.0,
            fontFamily: 'SFPro',
            fontSize: 12,
          ),
        ),
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                letterSpacing: 2.0,
                fontFamily: 'SFPro',
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
        isExpanded: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.icon,
          contentPadding: const EdgeInsets.fromLTRB(0, 12, 10, 0),
        ),
      ),
    );
  }
}
