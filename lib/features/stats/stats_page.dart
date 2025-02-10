import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/constants.dart' as consts;
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime dateTo = DateTime.now();
  DateTime dateFrom = DateTime.now();

  String? qrValue;
  Map<String, dynamic>? qrData;
  User? user;
  final database = DatabaseService();
  GetValues? dbGetter;
  List? historyItems;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    database.getUsers().listen((snapshot) {
      List<dynamic> users = snapshot.docs;
      dbGetter = GetValues(user: user!, users: users);
    });
    checkValuePeriodically();
    setState(() {});
  }

  void checkValuePeriodically() async {
    while (dbGetter?.getUser() == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    historyItems = dbGetter!.getUser()!.history.map((element) => jsonDecode(element)).toList();
    setState(() {});
  }

  Future<void> _pickDate(String period) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: period == 'from' ? dateFrom : dateTo,
      firstDate: period == 'from' ? DateTime(2025) : dateFrom,
      lastDate: period == 'from' ? dateTo : DateTime.now(),
    );

    if (pickedDate != null) {
      if (period == 'from') {
        dateFrom = pickedDate;
      } else {
        dateTo = pickedDate;
      }
      setState(() {});
    }
  }

  Map<String, int> filterItems(List items) {
    String formatDate(String input) {
      List<String> parts = input.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${int.parse(parts[1]) < 10 ? '0${parts[1]}' : parts[1]}-${int.parse(parts[0]) < 10 ? '0${parts[0]}' : parts[0]}';
      }
      return input;
    }

    int addedCount = 0;
    int deletedCount = 0;
    for (var entry in items) {
      log("$entry");
      DateTime entryDate = DateTime.parse(formatDate(entry["date"]));
      if (entryDate.isAfter(dateFrom.subtract(Duration(days: 1))) &&
          entryDate.isBefore(dateTo.add(Duration(days: 1)))) {
        if (entry["type"] == "added") {
          if (_controller.text == '' || _controller.text == 'Всего')
            addedCount++;
          else {
            if (_controller.text == entry["productType"]) {
              addedCount++;
            }
          }
        } else if (entry["type"] == "deleted") {
          if (_controller.text == '' || _controller.text == 'Всего')
            deletedCount++;
          else {
            if (_controller.text == entry["productType"]) {
              deletedCount++;
            }
          }
        }
      }
    }

    return {
      "added": addedCount,
      "deleted": deletedCount,
      "difference": addedCount - deletedCount,
    };
  }

  final List<String> menuList = ['Всего', ...consts.defaultTypes];

  @override
  Widget build(BuildContext context) {
    if (historyItems != null) {
      var result = filterItems(historyItems!);
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(chosen: 2),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 60,
            automaticallyImplyLeading: true,
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.black,
            backgroundColor: Color(CustomColors.shadowLight),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundGrad(),
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            ),
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.white, size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            title: const Text('Статистика',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 40,
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(16, 0, 0, 0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.search, size: 24, color: Color(CustomColors.bright)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 244,
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(width: 400), // 18 - fontSize
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 30,
                            controller: _controller,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 14),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "",
                              labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                        color: Color(CustomColors.bright),
                      ),
                      onSelected: (String value) {
                        _controller.text = '$value';
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) {
                        return menuList.map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem<String>(
                            padding: EdgeInsets.all(8),
                            height: 5,
                            value: value,
                            child: Text(value),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 25),
                  Text(
                    'Дата от:',
                    style: TextStyle(color: Color(CustomColors.bright), fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'Дата до:',
                    style: TextStyle(color: Color(CustomColors.bright), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 25),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () async {
                        _pickDate('from');
                      },
                      icon: Icon(Icons.calendar_month, color: Color(CustomColors.bright))),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 3)]),
                    child: Text(
                      '${dateFrom.day < 10 ? '0' + dateFrom.day.toString() : dateFrom.day}.${dateFrom.month < 10 ? '0' + dateFrom.month.toString() : dateFrom.month}.${dateFrom.year}',
                      style: TextStyle(color: Color(CustomColors.bright), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        _pickDate('to');
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Color(CustomColors.bright),
                      )),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 3)]),
                    child: Text(
                        '${dateTo.day < 10 ? '0' + dateTo.day.toString() : dateTo.day}.${dateTo.month < 10 ? '0' + dateTo.month.toString() : dateTo.month}.${dateTo.year}',
                        style: TextStyle(color: Color(CustomColors.bright), fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(width: 25)
                ],
              ),
              SizedBox(height: 25),
              historyItems != null
                  ? SizedBox(
                      width: 360,
                      height: MediaQuery.sizeOf(context).height / 1.5,
                      child: BarChart(BarChartData(
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(toY: filterItems(historyItems!)["added"]!.toDouble(), color: Colors.green)
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(toY: filterItems(historyItems!)["deleted"]!.toDouble(), color: Colors.red)
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                toY: filterItems(historyItems!)["difference"]!.toDouble(),
                                color: Colors.blue,
                              )
                            ]),
                          ],
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false), // Убираем цифры сверху (ось X)
                            ),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      if (value == filterItems(historyItems!)["added"]!.toDouble() ||
                                          value == filterItems(historyItems!)["deleted"]!.toDouble() ||
                                          value == filterItems(historyItems!)["difference"]!.toDouble()) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Text(
                                            '${value.toInt().toString()}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ); // Показываем только нужные метки
                                      }
                                      return Container(); // Скрываем остальные
                                    },
                                    reservedSize: 30)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                              interval: historyItems!.length / (historyItems!.length / 3).toDouble(),
                              reservedSize: 30,
                              showTitles: true,
                            )),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                interval: 10,
                                reservedSize: 100,
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return Container(
                                          alignment: Alignment.topLeft,
                                          height: 100,
                                          width: 130,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 40),
                                            child: Text(
                                              "Добавлено продуктов",
                                            ),
                                          ));
                                    case 1:
                                      return Container(
                                          alignment: Alignment.topCenter,
                                          height: 100,
                                          width: 130,
                                          child: Padding(
                                            padding: const EdgeInsets.only(),
                                            child: Text(
                                              "Удалено продуктов",
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                    case 2:
                                      return Container(
                                          alignment: Alignment.topRight,
                                          height: 100,
                                          width: 140,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 40),
                                            child: Text(
                                              "Продуктов в наличии",
                                              textAlign: TextAlign.end,
                                            ),
                                          ));
                                    default:
                                      return Text("");
                                  }
                                },
                              ),
                            ),
                          ))),
                    )
                  : CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
