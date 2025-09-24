import 'package:flutter/material.dart';

import '../models/country_code_model.dart';
import '../models/dialog_config.dart';
import 'country_widget.dart';
import 'rixa_textfield.dart';

class CountryCodeBottomSheet extends StatefulWidget {
  final List<CountryCodeModel> countries;
  final List<CountryCodeModel>? suggestedCountries;
  final Function(CountryCodeModel countryCodeModel) onSelected;
  final CountryCodeModel? selected;
  final DialogConfig dialogConfig;
  const CountryCodeBottomSheet(
      {super.key,
      required this.countries,
      required this.suggestedCountries,
      required this.onSelected,
      this.selected,
      required this.dialogConfig});

  @override
  State<CountryCodeBottomSheet> createState() => _CountryCodeBottomSheetState();
}

class _CountryCodeBottomSheetState extends State<CountryCodeBottomSheet> {
  late List<CountryCodeModel> mainCountries, searchCountries, suggestedCountries;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    mainCountries = widget.countries;
    suggestedCountries = widget.suggestedCountries ?? [];
    searchCountries = widget.countries.toList();
    for (var country in widget.suggestedCountries ?? []) {
      searchCountries.removeAt(searchCountries.indexWhere((element) => element.code == country.code));
    }
    searchCountries = suggestedCountries + searchCountries;
    searchController.addListener(listenSearchController);

    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(listenSearchController);
    super.dispose();
  }

  void listenSearchController() {
    search(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: Container(
                height: 5,
                width: 145,
                decoration:
                    BoxDecoration(color: widget.dialogConfig.topBarColor, borderRadius: BorderRadius.circular(30)),
              )),
              const SizedBox(height: 25),
              Text(
                widget.dialogConfig.title,
                style: widget.dialogConfig.titleStyle,
              ),
              const SizedBox(height: 14),
              RixaTextField(
                hintText: widget.dialogConfig.searchHintText,
                controller: searchController,
                textStyle: widget.dialogConfig.searchBoxTextStyle,
                hintStyle: widget.dialogConfig.searchBoxHintStyle,
                radius: widget.dialogConfig.searchBoxRadius,
                enabledColor: Colors.transparent,
                focusedColor: Colors.transparent,
                prefixIcon: widget.dialogConfig.searchBoxPrefixIcon ??
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 24),
                      child: Icon(
                        Icons.search,
                        color: widget.dialogConfig.searchBoxIconColor,
                        size: 20,
                      ),
                    ),
                suffixIcon: widget.dialogConfig.searchBoxSuffixIcon,
                isUnderline: false,
                noInputBorder: true,
                backgroundColor: widget.dialogConfig.searchBoxBackgroundColor,
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              children: [
                if (widget.selected != null && searchCountries.any((element) => element.code == widget.selected?.code))
                  TextButton(
                      onPressed: () {
                        widget.onSelected(widget.selected!);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: CountryWidget(
                          countryCodeModel: widget.selected!, isSelected: true, dialogConfig: widget.dialogConfig)),
                for (var country in searchCountries.where((element) => element.code != widget.selected?.code))
                  TextButton(
                      onPressed: () {
                        widget.onSelected(country);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          overlayColor: widget.dialogConfig.splashColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.dialogConfig.splashRadius ?? 0))),
                      child: CountryWidget(
                          countryCodeModel: country, isSelected: false, dialogConfig: widget.dialogConfig))
              ],
            ),
          )
        ],
      ),
    );
  }

  void search(String search) {
    if (num.tryParse(search) != null) {
      searchCountries =
          mainCountries.where((element) => element.dial_code.toString().contains(search.toString())).toList();
      setState(() {});
    } else {
      searchCountries =
          mainCountries.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList();
      setState(() {});
    }
  }
}
