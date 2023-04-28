/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/config.dart';
import '../../../data/data.dart';
import '../item/item.dart';
import '../loading/loading.dart';

class CallHistoryCard extends _CallHistoryCardWidget {
  const CallHistoryCard({
    required List<CallHistory> data,
    super.key,
  }) : super(
          isLoading: false,
          data: data,
        );

  const CallHistoryCard.loading({super.key}) : super(isLoading: true);
}

class _CallHistoryCardWidget extends StatelessWidget {
  const _CallHistoryCardWidget({
    required this.isLoading,
    this.data,
    super.key,
  });

  final bool isLoading;
  final List<CallHistory>? data;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      assert(data != null, "data is required");
    }
    return (isLoading)
        ? const _CallCardLoading(
            key: Key("call_history_card_loading"),
          )
        : _CallCard(
            data!,
            key: const Key("call_history_card"),
          );
  }
}

class _CallCard extends StatelessWidget {
  const _CallCard(this.data, {super.key});

  final List<CallHistory> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
          child: _buildDateText(context),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing),
            child: Column(
              children: data.asMap().entries.map((e) {
                final index = e.key;
                final value = e.value;
                final isLastData = index == data.length - 1;

                return Column(
                  children: [
                    CallItem(value),
                    if (!isLastData) _buildDivider(),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateText(BuildContext context) {
    final localCreatedAt = (data.isEmpty) ? null : data.first.localCreatedAt;

    final localCreatedAtText = (localCreatedAt == null)
        ? null
        : DateFormat.yMMMd().format(localCreatedAt);

    final totalData = data.length;
    final totalDataText = totalData > 1 ? "($totalData)" : "";

    return Text(
      "${localCreatedAtText ?? ""} $totalDataText",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.fontPallets[2],
          ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: .5,
      indent: 65,
      height: 30,
    );
  }
}

class _CallCardLoading extends StatelessWidget {
  const _CallCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Row(
          children: [
            CustomShimmer(
              height: 50,
              width: 50,
              borderRadius: BorderRadius.circular(25),
            ),
            const SizedBox(width: kDefaultSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmer(
                  width: (100 + (math.Random().nextInt(100))).toDouble(),
                  height: 14,
                ),
                const SizedBox(height: kDefaultSpacing / 2),
                CustomShimmer(
                  width: (50 + (math.Random().nextInt(50))).toDouble(),
                  height: 12,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
