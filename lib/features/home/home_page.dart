import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/home/settings_dialog.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
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
                      colors: [const Color(0xff38CACF), const Color(0xFF32E474)],
                      style: const TextStyle(
                          fontSize: 45, fontFamily: 'Nunito', fontWeight: FontWeight.w800, letterSpacing: 2),
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
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(CustomColors.bright), width: 2.0))),
                      child: Text(
                        "Загрузить",
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const Flexible(child: SizedBox(width: 40)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.transparent, width: 2.0))),
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
                icon: const Icon(Icons.settings, size: 40),
                color: Color(CustomColors.main),
                onPressed: () =>
                    showDialog(context: context, builder: (BuildContext context) => const SettingsDialog()),
              ),
              const SizedBox(width: 30)
            ],
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 40),
                  Container(
                    decoration:
                        BoxDecoration(color: Color(CustomColors.shadowLight), borderRadius: BorderRadius.circular(15)),
                    height: 570,
                    width: 360,
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 70,
                          child: Text(
                            'Добавить фотографии с нотами',
                            style:
                                TextStyle(color: Color(CustomColors.bright), fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Название',
                              style:
                                  TextStyle(color: Color(CustomColors.main), fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 35,
                              width: 280,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(offset: Offset(0, 2), color: Colors.black12, blurRadius: 2)]),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 260,
                                    height: 35,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints.expand(width: 400),
                                        child: TextField(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                                          maxLength: 20,
                                          onChanged: (value) => setState(() {}),
                                          decoration: const InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            contentPadding: EdgeInsets.only(bottom: 14),
                                            counterText: "",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Кол-во листов',
                              style:
                                  TextStyle(color: Color(CustomColors.main), fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 35,
                              width: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: [BoxShadow(offset: Offset(0, 2), color: Colors.black12, blurRadius: 2)],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 260,
                                    height: 35,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints.expand(width: 400),
                                        child: TextField(
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87),
                                          maxLength: 20,
                                          onChanged: (value) => setState(() {}),
                                          decoration: const InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
                                            contentPadding: EdgeInsets.only(bottom: 14),
                                            counterText: "",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        SvgPicture.asset(
                          'images/warn.svg',
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: Text(
                            'Файлы принимаются формата .jpg или .png и весом не более 5Мб',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(CustomColors.mainLight), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 150,
                          decoration: BoxDecoration(
                              gradient: BackgroundGrad(),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(spreadRadius: 1, offset: Offset(0, 2), blurRadius: 2, color: Colors.black26)
                              ]),
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Загрузить', style: TextStyle(color: Colors.white, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent, backgroundColor: Colors.transparent)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                        onPressed: () async {
                          await auth.signOut();
                          setState(() {});
                        },
                        child: const Text('Разлогинься')),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
