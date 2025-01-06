import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Text('бурдаrertretertretertertertertetretert'),
      ),
    );
  }
}
