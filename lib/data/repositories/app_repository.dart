/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu May 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/core.dart';
import '../../data/data.dart';
import '../../injection.dart';

abstract class AppRepository {
  /// Return `true` if the current app version is under the minimum version and
  /// needs to be updated
  bool get isOutdated;

  /// {@macro get_minimum_version}
  Future<void> checkMinimumVersion();
}

class AppRepositoryImpl extends AppRepository {
  final AppProvider _appProvider = sl<AppProvider>();
  final DeviceInfo _deviceInfo = sl<DeviceInfo>();
  final Logger _logger = Logger("App Repository");

  @override
  bool get isOutdated => _appProvider.getIsOutdated() ?? false;

  @override
  Future<void> checkMinimumVersion() async {
    late PackageInfo packageInfo;

    // We don't register the PackageInfo on injection.dart because
    // PackageInfo.fromPlatform() need to be call after runApp().
    //
    // Calling to PackageInfo.fromPlatform() before the runApp() call will
    // cause an exception.
    // see: https://github.com/fluttercommunity/plus_plugins/issues/309
    if (!sl.isRegistered<PackageInfo>()) {
      packageInfo = await PackageInfo.fromPlatform();
      sl.registerSingleton<PackageInfo>(packageInfo);
    } else {
      packageInfo = sl<PackageInfo>();
    }

    bool isOutdated = false;

    try {
      final data = await _appProvider.getMinimumVersion();

      Map<String, dynamic>? version;
      if (_deviceInfo.isAndroid()) {
        version = Parser.getMap(data["android"]);
      } else if (_deviceInfo.isIOS()) {
        version = Parser.getMap(data["ios"]);
      }

      if (version != null) {
        int? currentBuildNumber = Parser.getInt(packageInfo.buildNumber);
        int? buildNumber = Parser.getInt(version["build_number"]);

        // Check current version under minimum version
        if (currentBuildNumber != null &&
            buildNumber != null &&
            currentBuildNumber < buildNumber) {
          _logger.warning("Is outdated version app");
          isOutdated = true;
        }
      }
    } catch (_) {
    } finally {
      await _appProvider.setIsOutdated(isOutdated);
    }
  }
}
