import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';

// ignore: must_be_immutable
class BackgroundGrad extends LinearGradient {
  BackgroundGrad()
      : super(
          colors: [Color(CustomColors().getBackgroundGrad[0]), Color(CustomColors().getBackgroundGrad[1])],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          tileMode: TileMode.decal,
        );
}
