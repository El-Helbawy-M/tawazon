import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget drawSvgIcon(String iconName, {double? width, double? height, Color? iconColor,bool doRotate = false,}) => RotatedBox(
  quarterTurns: doRotate ? 2 : 0,
  child: SizedBox(
        width: width ?? 24,
        height: height ?? 24,
        child: SvgPicture.asset(
          "assets/icons/$iconName.svg",
          color: iconColor,
        ),
      ),
);
