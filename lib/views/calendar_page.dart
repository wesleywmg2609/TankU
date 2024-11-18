import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_date_field.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_text.dart';

class CalendarPage extends StatefulWidget {
  final User user;

  CalendarPage({
    super.key,
    required this.user,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  MyBoxShadows shadows = MyBoxShadows();
  final EasyInfiniteDateTimelineController _timelineController =
      EasyInfiniteDateTimelineController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _focusDate = DateTime.now();
  bool _isToday = true;
  bool _isPlanning = true;

  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _focusDate = today;
    _dateController.text = DateFormat('dd/MM/yyyy').format(today);
  }

  void _updateDateField() {
    _dateController.text = DateFormat('dd/MM/yyyy').format(_focusDate);
    _isToday = _focusDate == DateTime(today.year, today.month, today.day);
  }

  void _onDateChange(DateTime selectedDate) {
    setState(() {
      _focusDate = selectedDate;
      _updateDateField();
      _timelineController.animateToDate(selectedDate);
    });
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, {bool isPressed = false}) {
    return MyButton(
      onPressed: onPressed,
      resetAfterPress: false,
      isPressed: isPressed,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: MyText(
        text: label,
        letterSpacing: 2.0,
        isBold: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            EasyInfiniteDateTimeLine(
              controller: _timelineController,
              firstDate: DateTime(_focusDate.year),
              focusDate: _focusDate,
              lastDate: DateTime(_focusDate.year, 12, 31),
              onDateChange: _onDateChange,
              showTimelineHeader: false,
              timeLineProps: const EasyTimeLineProps(
                hPadding: 0,
                separatorPadding: 0,
              ),
              dayProps: const EasyDayProps(
                width: 96,
                height: 128,
              ),
              itemBuilder: (
                BuildContext context,
                DateTime date,
                bool isSelected,
                VoidCallback onTap,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: MyButton(
                    onPressed: onTap,
                    resetAfterPress: false,
                    isPressed: !isSelected,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: EasyDateFormatter.shortMonthName(date, "en_US")
                              .toUpperCase(),
                          letterSpacing: 2.0,
                          size: 12,
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          text: date.day.toString(),
                          letterSpacing: 2.0,
                          isBold: true,
                          size: 20,
                        ),
                        const SizedBox(height: 5),
                        MyText(
                          text: EasyDateFormatter.shortDayName(date, "en_US")
                              .toUpperCase(),
                          letterSpacing: 2.0,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: MyDateField(
                      controller: _dateController,
                      icon: const MyIcon(icon: Icons.calendar_month),
                      initialDate: _focusDate,
                      onDateSelected: _onDateChange,
                      firstDate: DateTime(_focusDate.year),
                      lastDate: DateTime(_focusDate.year, 12, 31),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildActionButton('Today', () => _onDateChange(today), isPressed: !_isToday),
                ],
              ),
            ),
            if (_isToday)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildActionButton('Plan', () {
                    setState(() {
                      if (!_isPlanning) {
                        _isPlanning = !_isPlanning;
                      }  
                    });
                  }, isPressed: _isPlanning)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildActionButton('Schedule', () {
                    setState(() {
                      if (_isPlanning) {
                        _isPlanning = !_isPlanning;
                      }  
                    });
                  }, isPressed: !_isPlanning)),
                ],
              ),
            ) else if (_focusDate.isAfter(today))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(child: _buildActionButton('Schedule', () {
                    setState(() {
                      if (_isPlanning) {
                        _isPlanning = !_isPlanning;
                      }  
                    });
                  }, isPressed: !_isPlanning)),
                ],
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
