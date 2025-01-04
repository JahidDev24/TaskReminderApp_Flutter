import 'package:flutter/material.dart';

class MyColors {
  static const PrimaryColor = Colors.blue;
  static const PurpleColor = Colors.purple;
  static const textFieldBorderColor = Color(0xffbdbdbd);

  List<Colormodel> randomcolors = [
    Colormodel(
        bgcolor: Colors.deepPurple,
        opColor: getOppositeColor(Colors.deepPurple)),
    Colormodel(bgcolor: Colors.teal, opColor: getOppositeColor(Colors.teal)),
    Colormodel(
        bgcolor: Colors.indigo, opColor: getOppositeColor(Colors.indigo)),
    Colormodel(
        bgcolor: Colors.orange, opColor: getOppositeColor(Colors.orange)),
    Colormodel(
        bgcolor: Colors.pinkAccent,
        opColor: getOppositeColor(Colors.pinkAccent)),
    Colormodel(bgcolor: Colors.green, opColor: getOppositeColor(Colors.green)),
  ];
}

Color getOppositeColor(Color color) {
  // Calculate luminance to decide the opposite color
  double luminance =
      (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  return luminance > 0.5
      ? Colors.black
      : Colors.white; // Light backgrounds get black text, dark get white text
}

class Colormodel {
  Color bgcolor;
  Color opColor;
  Colormodel({required this.bgcolor, required this.opColor});
}
