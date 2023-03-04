/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Feb 14 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';
import 'package:custom_icons/custom_icons.dart';
import 'package:flutter/material.dart';
import '../../../config/config.dart';
import '../../../data/data.dart';
import '../utility/utility.dart';

class LanguageSelectionCard extends _LanguageSelectionCardWrapper {
  const LanguageSelectionCard.builder({
    required List<Language> selected,
    required List<Language> selection,
    required Function(Language selected) onSelected,
    Key? key,
  }) : super(
          isBuilder: true,
          isLoading: false,
          builderOnSelected: onSelected,
          builderSelected: selected,
          builderSelection: selection,
          key: key,
        );
}

class _LanguageSelectionCardWrapper extends StatelessWidget {
  const _LanguageSelectionCardWrapper({
    required this.isBuilder,
    required this.isLoading,
    this.builderOnSelected,
    this.builderSelected,
    this.builderSelection,
    Key? key,
  }) : super(key: key);

  final Function(Language selected)? builderOnSelected;
  final List<Language>? builderSelected;
  final List<Language>? builderSelection;

  final bool isLoading;
  final bool isBuilder;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      if (isBuilder) {
        assert(
          builderOnSelected != null &&
              builderSelected != null &&
              builderSelection != null,
          "builderOnCompleted, builderSelected, builderSelection is required",
        );
      }
    }

    if (isLoading) {
      return const SizedBox();
    } else {
      if (isBuilder) {
        return _LanguageSelectionCardBuilder(
          selected: builderSelected!,
          selection: builderSelection!,
          onSelected: builderOnSelected!,
          key: key,
        );
      } else {
        return const SizedBox();
      }
    }
  }
}

class _LanguageSelectionCardBuilder extends StatefulWidget {
  const _LanguageSelectionCardBuilder({
    required this.selected,
    required this.selection,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final List<Language> selected;
  final List<Language> selection;
  final Function(Language selected) onSelected;

  @override
  State<_LanguageSelectionCardBuilder> createState() =>
      _LanguageSelectionCardBuilderState();
}

class _LanguageSelectionCardBuilderState
    extends State<_LanguageSelectionCardBuilder> {
  Timer? _debounce;

  late List<Language> selection;
  @override
  void initState() {
    super.initState();

    selection = widget.selection;
  }

  @override
  Widget build(BuildContext context) {
    return BrightnessBuilder(builder: (context, brightness) {
      return Column(
        children: [
          _buildSearchField(),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Expanded(child: _buildSelectionLanguage()),
        ],
      );
    });
  }

  Widget _buildSearchField() {
    return TextField(
      key: const Key("language_selection_card_search_field"),
      autofocus: true,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.fontPallets[0],
          ),
      onChanged: (value) => onChanged(value),
      decoration: const InputDecoration(
        prefixIcon: Icon(CustomIcons.search),
        isDense: true,
      ),
    );
  }

  Widget _buildSelectionLanguage() {
    return ListView.separated(
      itemCount: selection.length,
      itemBuilder: (context, index) {
        bool isSelected = widget.selected
            .where((e) => e.code == selection[index].code)
            .isNotEmpty;
        return _LanguageSelectionCardItem(
          selection[index],
          selected: isSelected,
          onTap: () {
            if (!isSelected) {
              widget.onSelected(selection[index]);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: .2,
          height: .2,
        );
      },
    );
  }

  void onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      value = value.toLowerCase();
      final filterSelection = widget.selection
          .where((language) =>
              (language.code?.toLowerCase().contains(value) ?? false) ||
              (language.name?.toLowerCase().contains(value) ?? false) ||
              (language.nativeName?.toLowerCase().contains(value) ?? false))
          .toList();

      setState(() {
        selection = filterSelection;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }
}

class _LanguageSelectionCardItem extends StatelessWidget {
  const _LanguageSelectionCardItem(
    this.data, {
    this.selected,
    Key? key,
    this.onTap,
  }) : super(key: key);

  final Language data;
  final bool? selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildName(context),
                    _buildNativeName(context),
                  ],
                ),
              ),
              if (selected != null) const SizedBox(width: kDefaultSpacing),
              if (selected != null) _buildSelected(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelected(BuildContext context) {
    return (selected == true)
        ? Icon(
            Icons.check,
            key: Key("language_selection_card_item_check_icon_${data.code}"),
            color: AppColors.green,
          )
        : const SizedBox();
  }

  Widget _buildName(BuildContext context) {
    return Text(
      data.name ?? "-",
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: AppColors.fontPallets[0]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNativeName(BuildContext context) {
    return Text(
      data.nativeName ?? "-",
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.fontPallets[2]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
