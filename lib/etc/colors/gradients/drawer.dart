import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';

// ignore: must_be_immutable
class DrawerGrad extends LinearGradient {
  DrawerGrad()
      : super(
          colors: [
            Color(CustomColors().getDrawerGrad[0]),
            Color(CustomColors().getDrawerGrad[1]),
            Color(CustomColors().getDrawerGrad[2])
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          tileMode: TileMode.decal,
        );
}
