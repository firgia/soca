/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';

/// Implement this Responsive layout when creating screen or page.
///
/// Use [ResponsiveBuilder] to render this implementation.
abstract class ResponsiveLayoutInterface {
  /// Render the mobile layout design
  Widget buildMobileLayout(
    BuildContext context,
    BoxConstraints constraints,
  );

  /// Render the tablet layout design
  Widget buildTabletLayout(
    BuildContext context,
    BoxConstraints constraints,
  );
}
