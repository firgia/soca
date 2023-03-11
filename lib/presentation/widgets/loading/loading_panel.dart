/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import '../../../config/config.dart';
import 'adaptive_loading.dart';

class LoadingPanel extends StatelessWidget {
  const LoadingPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.barrier,
      child: const AdaptiveLoading(
        radius: 24,
        color: Colors.white,
      ),
    );
  }
}
