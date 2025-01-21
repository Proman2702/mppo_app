import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/features/home/settings_dialog.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            toolbarHeight: 100,
            leadingWidth: 260,
            automaticallyImplyLeading: true,
            backgroundColor: Color(CustomColors.shadowLight),
            leading: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'images/activity.svg',
                          colorFilter: ColorFilter.mode(Color(CustomColors.bright), BlendMode.srcIn),
                          width: 60,
                          height: 60,
                        ),
                        SvgPicture.asset(
                          'images/note.svg',
                          colorFilter: ColorFilter.mode(Color(CustomColors.main), BlendMode.srcIn),
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GradientText(
                      "NoteAI",
                      colors: [Color(0xff38CACF), Color(0xFF32E474)],
                      style:
                          TextStyle(fontSize: 45, fontFamily: 'Nunito', fontWeight: FontWeight.w800, letterSpacing: 2),
                    )
                  ],
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 130),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/'),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration:
                          BoxDecoration(border: Border(bottom: BorderSide(color: Colors.transparent, width: 2.0))),
                      child: Text(
                        "Загрузить",
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const Flexible(
                    child: SizedBox(
                      width: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(CustomColors.bright), width: 2.0))),
                      child: Text(
                        "Помощь",
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, size: 40),
                color: Color(CustomColors.main),
                onPressed: () => showDialog(context: context, builder: (BuildContext context) => SettingsDialog()),
              ),
              SizedBox(width: 30)
            ],
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              GradientText(
                'Хрен вам а не помощь',
                colors: [
                  Color.fromARGB(255, 0, 255, 42),
                  Color.fromARGB(255, 255, 0, 132),
                  Color.fromARGB(255, 136, 0, 255)
                ],
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
