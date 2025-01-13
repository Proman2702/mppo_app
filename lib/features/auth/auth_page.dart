import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 250,
                  height: 150,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
