import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(chosen: 2),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 70,
            automaticallyImplyLeading: true,
            backgroundColor: Color(CustomColors.shadowLight),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundGrad(),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            ),
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white, size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            title: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text('Статистика',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('бурда v2')],
          ),
        ),
      ),
    );
  }
}
