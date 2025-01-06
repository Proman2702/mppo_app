import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';

// ignore: must_be_immutable
class TileGrad1 extends LinearGradient {
  TileGrad1()
      : super(
          colors: [Color(CustomColors().getTileGrad1[0]), Color(CustomColors().getTileGrad1[1])],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.decal,
        );
}

class TileGrad2 extends LinearGradient {
  TileGrad2()
      : super(
          colors: [Color(CustomColors().getTileGrad2[0]), Color(CustomColors().getTileGrad2[1])],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.decal,
        );
}

class TileGrad3 extends LinearGradient {
  TileGrad3()
      : super(
          colors: [Color(CustomColors().getTileGrad3[0]), Color(CustomColors().getTileGrad3[1])],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.decal,
        );
}

class ButtonGrad extends LinearGradient {
  ButtonGrad()
      : super(
          colors: [Color(CustomColors().getButtonGrad[1]), Color(CustomColors().getButtonGrad[0])],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.decal,
        );
}

class GreyTile extends LinearGradient {
  GreyTile()
      : super(
          colors: [Color(CustomColors().getGreyTile[0]), Color(CustomColors().getGreyTile[1])],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.decal,
        );
}
