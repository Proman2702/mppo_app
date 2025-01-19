import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              Text("бурда"),
              ElevatedButton(
                  onPressed: () async {
                    await auth.signOut();
                    setState(() {});
                  },
                  child: Text('Разлогинься'))
            ],
          ),
        ),
      ),
    );
  }
}
