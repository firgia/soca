/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

class YearDropdown extends StatelessWidget {
  const YearDropdown({
    required this.items,
    this.value,
    this.onChanged,
    super.key,
  });

  final String? value;
  final List<String> items;
  final Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox();
    } else {
      return Container(
        height: 50,
        color: Theme.of(context).cardColor,
        child: DropdownButton<String>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
          isExpanded: false,
          underline: const SizedBox(),
        ),
      );
    }
  }
}
