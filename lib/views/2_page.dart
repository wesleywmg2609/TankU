import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_button.dart';
import 'package:tanku/components/my_text.dart';

// ignore: must_be_immutable
class Page2 extends StatefulWidget {
  final User user;

  Page2({
    super.key,
    required this.user,
  });

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  MyBoxShadows shadows = MyBoxShadows();
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
  DateTime _focusDate = DateTime.now();
  DateTime get _firstDate => DateTime(DateTime.now().year);
  DateTime get _lastDate => DateTime(DateTime.now().year, 12, 31);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              child: EasyInfiniteDateTimeLine(
                controller: _controller,
                firstDate: _firstDate,
                focusDate: _focusDate,
                lastDate: _lastDate,
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
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
            ),
          ],
        )));
  }
}
