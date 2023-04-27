/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Apr 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../config/config.dart';
import '../../../data/data.dart';

class CallStatisticChart extends StatelessWidget {
  const CallStatisticChart({
    required this.dataSource,
    this.preferLastData = true,
    this.height = 250,
    this.xSpacing = 80,
    Key? key,
  }) : super(key: key);

  final List<CallDataMounthly> dataSource;
  final bool preferLastData;
  final double height;
  final double xSpacing;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final totalShowData = (width / xSpacing).floor();

    return SizedBox(
      height: height,
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          zoomMode: ZoomMode.x,
          enablePanning: true,
          enableMouseWheelZooming: true,
          enableSelectionZooming: false,
        ),
        margin: const EdgeInsets.all(kDefaultSpacing),
        primaryXAxis: CategoryAxis(
          isVisible: true,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          interval: 1,
          autoScrollingMode: AutoScrollingMode.end,
          majorTickLines: const MajorTickLines(width: 0),
          visibleMinimum: _visibleMinimumX(totalShowData).toDouble(),
          visibleMaximum: _visibleMaximumX(totalShowData).toDouble(),
        ),
        primaryYAxis: NumericAxis(
          isVisible: true,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: const MajorGridLines(
            width: .8,
            dashArray: [5, 5],
          ),
          plotOffset: 10,
          maximum: _maximumY.toDouble(),
          desiredIntervals: 5,
          minimum: 0,
          visibleMinimum: 0,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          header: "",
          canShowMarker: false,
          shouldAlwaysShow: true,
          format: "point.y",
        ),
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        plotAreaBackgroundColor: Colors.transparent,
        plotAreaBorderColor: Colors.transparent,
        series: [
          SplineAreaSeries<CallDataMounthly, String>(
            dataSource: dataSource,
            animationDelay: 500,
            animationDuration: 3000,
            enableTooltip: true,
            xValueMapper: (CallDataMounthly data, _) => data.month,
            yValueMapper: (CallDataMounthly data, _) => data.total,
            markerSettings: MarkerSettings(
              isVisible: true,
              borderColor: Theme.of(context).primaryColorLight,
            ),
            borderColor: Theme.of(context).primaryColorLight,
            borderDrawMode: BorderDrawMode.top,
            borderWidth: 2,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColorLight.withOpacity(.3),
                Theme.of(context).primaryColorLight.withOpacity(.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            splineType: SplineType.monotonic,
            isVisible: true,
          ),
        ],
      ),
    );
  }

  int _visibleMinimumX(int totalShowData) {
    final lenght = dataSource.length;

    if (lenght > totalShowData) {
      if (preferLastData) {
        int min = lenght - totalShowData;

        return min;
      }
    }

    return 0;
  }

  int _visibleMaximumX(int totalShowData) {
    final lenght = dataSource.length;

    if (lenght > totalShowData) {
      if (!preferLastData) {
        return totalShowData - 1;
      }
    }

    return lenght - 1;
  }

  int get _maximumY {
    int higher = 0;
    for (var e in dataSource) {
      if (e.total != null && e.total! > higher) {
        higher = e.total!;
      }
    }

    final mod = higher % 10;

    if (mod > 0) {
      higher -= mod;
      higher += 10;
    }

    return higher;
  }
}
