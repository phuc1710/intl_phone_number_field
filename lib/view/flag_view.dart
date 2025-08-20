// import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:world_flags/world_flags.dart';

import '../models/country_code_model.dart';

class FlagView extends StatelessWidget {
  final CountryCodeModel countryCodeModel;
  final Size size;
  final bool isFlat;
  final BoxDecoration? decoration;
  const FlagView(
      {required this.countryCodeModel, required this.size, required this.isFlat, this.decoration, super.key});

  @override
  Widget build(BuildContext context) {
    return isFlat
        ? CountryFlag.simplified(
            WorldCountry.fromAnyCode(countryCodeModel.code.toUpperCase()),
            width: countryCodeModel.code.toUpperCase() == "NP" ? size.height : size.width,
            height: size.height,
            decoration: decoration,
          )
        : Text(
            countryCodeModel.code.toUpperCase().replaceAllMapped(
                RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397)),
            style: TextStyle(fontSize: size.height),
          );
  }
}
