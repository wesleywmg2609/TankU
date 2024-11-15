import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_date_field.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_text.dart';

// ignore: must_be_immutable
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
  TextEditingController _dateController = TextEditingController();
  DateTime _focusDate = DateTime.now();

  @override
  void initState() {
    super.initState();
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
              onDateChange: (selectedDate) {
                setState(() {
                  _focusDate = selectedDate;
                });
              },
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
                        initialDate: _focusDate),
                  ),
                  const SizedBox(width: 10),
                  MyButton(
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    child: const MyText(
                      text: 'Today',
                      letterSpacing: 2.0,
                      isBold: true,
                    ),
                    isPressed: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: MyButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: const MyText(
                        text: 'Today',
                        letterSpacing: 2.0,
                        isBold: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyButton(
                      onPressed: () {},
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: const MyText(
                        text: 'Today',
                        letterSpacing: 2.0,
                        isBold: true,
                      ),
                      isPressed: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
