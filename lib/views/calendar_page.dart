import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tanku/helper/functions.dart';
import 'package:tanku/models/tank.dart';
import 'package:tanku/services/tank_service.dart';
import 'package:tanku/widgets/my_app_bar2.dart';

class CalendarPage extends StatefulWidget {
  final User user;

  const CalendarPage({
    super.key,
    required this.user,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late TankService _tankService;
  List<Tank?> _tanks = [];
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
    _tankService = Provider.of<TankService>(context, listen: false);
    _tankService.listenToAllTanksUpdates();

    _tankService.addListener(() {
      if (mounted) {
        setState(() {
          _tanks = _tankService.tanks;
        });
      }
    });
    _focusDate = today;
    startOfMonth = DateTime(today.year, today.month, 1);
    endOfMonth = DateTime(today.year, today.month + 1, 0);
  }

  @override
  void dispose() {
    _tankService.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: SafeArea(
          child: Column(
        children: [
          MyAppBar2(
            title: 'Calendar',
            subtitle: 'Good Morning!',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {});
            },
          ),
          Container(
            //color: Colors.green,
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
                              DateTime newDate =
                                  _focusDate.subtract(const Duration(days: 30));
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
                        Text(DateFormat('MMMM d, yyyy').format(_focusDate),
                            style: const TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 16,
                                color: Color(0xff282a29))),
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
                                  EasyDateFormatter.shortDayName(date, "en_US"),
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
          Expanded(
            child: Container(
              //color: Colors.lightGreen,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                  itemCount: _tanks.length,
                  itemBuilder: (context, index) {
                    var tank = _tanks[index];
                    return _buildTankItem(tank!);
                  },
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildTankItem(Tank tank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xff282a29),
                child: tank.imageUrl != null && tank.imageUrl!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          tank.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Ionicons.fish),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(tank.name,
                            style: const TextStyle(
                                fontFamily: 'NotoSans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff282a29))),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text('Freshwater',
                              style: TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 10,
                                  color: Color(0xffffffff))),
                        ),
                      ],
                    ),
                    Text(
                        DateFormat('MMMM d, yyyy')
                            .format(convertFromIso8601String(tank.setupAt)),
                        style: const TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14,
                            color: Color(0xff282a29))),
                  ],
                ),
              ),
              const Icon(Ionicons.chevron_down_outline,
                  color: Color(0xff282a29), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
