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
  DateTime _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
            child: Column(
          children: [
            EasyDateTimeLine(
              initialDate: _focusDate,
              onDateChange: (selectedDate) {
                setState(() {
                  _focusDate = selectedDate;
                });
              },
              headerProps: EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  dateFormatter: const DateFormatter.fullDateMonthAsStrDY(),
                  selectedDateStyle: TextStyle(
                    fontFamily: 'SFPro',
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 14,
                  ),
                  monthStyle: TextStyle(
                    fontFamily: 'SFPro',
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 2.0,
                    fontSize: 14,
                  ),
                  padding: const EdgeInsets.only(left: 16)
                ),
              timeLineProps:
                  const EasyTimeLineProps(
                    separatorPadding: 10
                  ),
              dayProps: const EasyDayProps(
                height: 128,
              ),
              itemBuilder: (
                BuildContext context,
                DateTime date,
                bool isSelected,
                VoidCallback onTap,
              ) {
                return SizedBox(
                  width: 96,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            size: 14,
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
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        )));
  }
}
