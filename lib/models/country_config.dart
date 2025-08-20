import 'package:flutter/material.dart';

enum DropDownIconPosition { leading, trailing }

class CountryConfig {
  bool noFlag;
  bool noCode;
  double spacing;
  TextStyle textStyle;
  Decoration decoration;
  bool flatFlag;
  Size flagSize;
  Widget Function(BuildContext)? dropDownIconBuilder;
  DropDownIconPosition dropDownIconPosition;
  CountryConfig({
    this.noFlag = false,
    this.noCode = false,
    this.spacing = 8,
    this.flagSize = const Size(30, 20),
    this.flatFlag = false,
    Decoration? decoration,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
    this.dropDownIconBuilder,
    this.dropDownIconPosition = DropDownIconPosition.trailing,
  })  : decoration = decoration ??
            BoxDecoration(
              border: Border.all(width: 2, color: const Color(0xFF3f4046)),
              borderRadius: BorderRadius.circular(8),
            ),
        assert(!(noFlag && noCode), 'You cannot set both noFlag and noCode to true');
}
