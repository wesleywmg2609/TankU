import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

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
  DateTime _focusDate = DateTime.now();

  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  late DateTime startOfMonth;
  late DateTime endOfMonth;

  @override
  void initState() {
    super.initState();
    _focusDate = today;
    startOfMonth = DateTime(today.year, today.month, 1);
    endOfMonth = DateTime(today.year, today.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            // color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Container(
                //color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calendar',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff282a29)),
                        ),
                        Text(
                          'Good Morning!',
                          style: TextStyle(
                              fontFamily: 'NotoSans',
                              fontSize: 20,
                              color: Color(0xff282a29)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: const Icon(
                        Ionicons.ellipsis_horizontal_circle_outline,
                        color: Color(0xff282a29),
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            //color: Colors.lightGreen,
            child: Container(
              //color: Colors.orange,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: const Icon(Icons.arrow_back_ios_rounded,
                                color: Color(0xff282a29)),
                            onTap: () {
                              setState(() {
                                DateTime newDate = _focusDate
                                    .subtract(const Duration(days: 30));
                                if (newDate.isAfter(
                                    today.subtract(const Duration(days: 93)))) {
                                  _focusDate = newDate;
                                  startOfMonth = DateTime(
                                      _focusDate.year, _focusDate.month, 1);
                                  endOfMonth = DateTime(
                                      _focusDate.year, _focusDate.month + 1, 0);
                                }
                              });
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  DateFormat('MMMM d, yyyy').format(_focusDate),
                                  style: const TextStyle(
                                      fontFamily: 'NotoSans',
                                      fontSize: 16,
                                      //fontWeight: FontWeight.bold,
                                      color: Color(0xff282a29))),
                            ],
                          ),
                          GestureDetector(
                            child: const Icon(Icons.arrow_forward_ios_rounded,
                                color: Color(0xff282a29)),
                            onTap: () {
                              setState(() {
                                DateTime newDate =
                                    _focusDate.add(const Duration(days: 30));
                                if (newDate.isBefore(
                                    today.add(const Duration(days: 93)))) {
                                  _focusDate = newDate;
                                  startOfMonth = DateTime(
                                      _focusDate.year, _focusDate.month, 1);
                                  endOfMonth = DateTime(
                                      _focusDate.year, _focusDate.month + 1, 0);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    EasyDateTimeLinePicker.itemBuilder(
                      firstDate: startOfMonth,
                      lastDate: endOfMonth,
                      focusedDate: _focusDate,
                      itemExtent: 70.0,
                      selectionMode: const SelectionMode.autoCenter(),
                      headerOptions: const HeaderOptions(
                        headerType: HeaderType.none,
                      ),
                      timelineOptions: const TimelineOptions(
                          height: 80, padding: EdgeInsets.all(0)),
                      daySeparatorPadding: 15,
                      itemBuilder: (context, date, isSelected, isDisabled,
                          isToday, onTap) {
                        return GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff282a29)
                                    : const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    EasyDateFormatter.shortDayName(
                                        date, "en_US"),
                                    style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontSize: 14,
                                        color: isSelected
                                            ? const Color(0xffffffff)
                                            : const Color(0xff282a29))),
                                Text(date.day.toString(),
                                    style: TextStyle(
                                        fontFamily: 'NotoSans',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xffffffff)
                                            : const Color(0xff282a29)))
                              ],
                            ),
                          ),
                        );
                      },
                      onDateChange: (date) {
                        setState(() {
                          _focusDate = date;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              //color: Colors.orange,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff282a29),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('My Lovely Tank',
                                        style: TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff282a29))),
                                    Text(
                                        DateFormat('MMMM d, yyyy')
                                            .format(_focusDate),
                                        style: const TextStyle(
                                            fontFamily: 'NotoSans',
                                            fontSize: 14,
                                            color: Color(0xff282a29))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                child: const Icon(
                                  Icons.expand_more_rounded,
                                  color: Color(0xff282a29),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
