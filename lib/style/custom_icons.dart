import 'package:flutter/material.dart';

class CustomIcons {
  static const IconData menu = IconData(0xe900, fontFamily: "CustomIcons");
  static const IconData option = IconData(0xe902, fontFamily: "CustomIcons");
}

class CustomColors {
  static const Color darkGrey = Color.fromRGBO(92, 110, 114, 1);
  static const Color lightGrey = Color.fromRGBO(100, 128, 132, 1);
  static const Color darkBlue = Color.fromRGBO(69, 105, 144, 1);
  static const Color darkBlue2 = Color.fromRGBO(81, 124, 170, 1);
  static const Color blue = Color.fromRGBO(17, 138, 178, 1);
  static const Color blue2 = Color.fromRGBO(23, 170, 221, 1);
  static const Color lightBlue = Color.fromRGBO(49, 214, 200, 1);
  static const Color green = Color.fromRGBO(166, 230, 90, 1);
  static const Color purple = Color.fromRGBO(122, 79, 148, 1);
}

class CustomTextStyle {

  double textSize; 
  FontWeight fontWeight;
  TextStyle style;

  CustomTextStyle(double textSize, FontWeight fontWeight) {
    this.textSize = textSize;
    this.fontWeight = fontWeight;
    style = getStyle();
  }

  TextStyle getStyle() {
    return TextStyle(
      color: Colors.white,
      fontFamily: "Montserrat",
      fontWeight: fontWeight,
      fontSize: textSize
    );
  }
}