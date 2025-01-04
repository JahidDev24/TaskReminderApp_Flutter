import 'package:flutter/cupertino.dart';

extension Space on int {
  Widget get toSpace {
    return SizedBox(
      height: toDouble(),
      width: toDouble(),
    );
  }
  
}
