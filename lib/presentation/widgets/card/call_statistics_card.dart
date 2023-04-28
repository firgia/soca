/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../chart/chart.dart';
import '../loading/loading.dart';

enum _WidgetType {
  callStatisticsCard,
  adaptiveLoadingCard,
  loadingCard,
  emptyCard,
}

class CallStatisticsCard extends _CallStatisticsWidget {
  const CallStatisticsCard({
    required List<CallDataMounthly> dataSource,
    required int? joinedDay,
    Widget? header,
    super.key,
  }) : super(
          type: _WidgetType.callStatisticsCard,
          dataSource: dataSource,
          header: header,
          joinedDay: joinedDay,
        );

  const CallStatisticsCard.adaptiveLoading({super.key})
      : super(type: _WidgetType.adaptiveLoadingCard);

  const CallStatisticsCard.loading({super.key})
      : super(type: _WidgetType.loadingCard);

  const CallStatisticsCard.empty({
    required UserType? userType,
    Widget? header,
    super.key,
  }) : super(
          type: _WidgetType.emptyCard,
          userType: userType,
          header: header,
        );
}

class _CallStatisticsWidget extends StatelessWidget {
  const _CallStatisticsWidget({
    required this.type,
    this.dataSource,
    this.joinedDay,
    this.header,
    this.userType,
    super.key,
  });

  final _WidgetType type;
  final List<CallDataMounthly>? dataSource;
  final int? joinedDay;
  final Widget? header;
  final UserType? userType;

  @override
  Widget build(BuildContext context) {
    if (type == _WidgetType.callStatisticsCard) {
      assert(dataSource != null, "dataSource is required");
    }

    switch (type) {
      case _WidgetType.callStatisticsCard:
        return _CallStatisticsCard(
          dataSource: dataSource!,
          joinedDay: joinedDay,
          header: header,
          key: const Key("call_statistics_card"),
        );
      case _WidgetType.adaptiveLoadingCard:
        return const _AdaptiveLoadingCard(
          key: Key("call_statistics_card_adaptive_loading"),
        );
      case _WidgetType.loadingCard:
        return const _LoadingCard(
          key: Key("call_statistics_card_loading"),
        );
      case _WidgetType.emptyCard:
        return _EmptyCard(
          userType: userType,
          header: header,
          key: const Key("call_statistics_card_empty"),
        );
    }
  }
}

class _CallStatisticsCard extends StatelessWidget {
  const _CallStatisticsCard({
    required this.dataSource,
    required this.joinedDay,
    this.header,
    super.key,
  });
  final List<CallDataMounthly> dataSource;
  final int? joinedDay;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            if (header != null) header!,
            CallStatisticChart(
              height: 250,
              dataSource: dataSource,
              xSpacing: 80,
              preferLastData: false,
            ),
            _buildJoinedDayText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinedDayText(BuildContext context) {
    final day = joinedDay;

    if (day != null && day >= 0) {
      final messages = LocaleKeys.joined_desc.tr().split(" ");
      final newMessages = LocaleKeys.joined_desc
          .tr(namedArgs: {"total": day.toString()}).split(" ");

      return Padding(
        key: const Key("call_statistics_joined_days_text"),
        padding: const EdgeInsets.only(bottom: kDefaultSpacing),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall,
            children: newMessages.map((msg) {
              final isExists =
                  messages.where((element) => element == msg).isNotEmpty;

              final isLast = newMessages.last == msg;

              return TextSpan(
                text: isLast ? msg : "$msg ",
                style: isExists
                    ? null
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.fontPallets[0],
                          fontWeight: FontWeight.w500,
                        ),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _AdaptiveLoadingCard extends StatelessWidget {
  const _AdaptiveLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: AdaptiveLoading(radius: 24),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.userType,
    this.header,
    super.key,
  });

  final Widget? header;
  final UserType? userType;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            if (header != null) header!,
            const SizedBox(height: kDefaultSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
              child: _buildNoCallDataText(context),
            ),
            _buildAnimation(),
            _buildDesc(context),
            const SizedBox(height: kDefaultSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return LottieBuilder.asset(
      ImageAnimation.comment,
      height: 150,
    );
  }

  Widget _buildDesc(BuildContext context) {
    if (userType == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: Text(
        (userType == UserType.blind)
            ? LocaleKeys.no_call_data_yet_blind_desc
            : LocaleKeys.no_call_data_yet_volunteer_desc,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ).tr(),
    );
  }

  Widget _buildNoCallDataText(BuildContext context) {
    return Text(
      LocaleKeys.no_call_data_yet,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).tr();
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
      child: LottieBuilder.asset(
        ImageAnimation.chartWebble,
        height: 300,
        width: double.infinity,
      ),
    );
  }
}
