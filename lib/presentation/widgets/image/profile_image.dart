/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 20 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../core/core.dart';
import '../../../injection.dart';
import '../loading/loading.dart';

class _Data {
  /// Image File
  final File? file;

  /// image asset
  final String? assetName;

  /// image network
  final String? src;

  final ImageProvider? image;

  const _Data({
    this.image,
    this.file,
    this.assetName,
    this.src,
  });

  bool isEmpty() {
    return image == null && file == null && assetName == null && src == null;
  }
}

class _Config {
  double radius;
  final ImageProvider? errorImage;

  _Config({
    this.radius = 50,
    this.errorImage,
  });
}

class ProfileImage extends _ProfileImageItem {
  ProfileImage(
    ImageProvider? image, {
    ImageProvider? customImage,
    double radius = 50,
    ImageProvider? errorImage,
    Key? key,
  }) : super(
          isLoading: false,
          config: _Config(
            radius: radius,
            errorImage: errorImage,
          ),
          data: _Data(image: image),
          key: key,
        );

  ProfileImage.network({
    required String? url,
    ImageProvider? customImage,
    double radius = 50,
    ImageProvider? errorImage,
    Key? key,
  }) : super(
          isLoading: false,
          config: _Config(
            radius: radius,
            errorImage: errorImage,
          ),
          data: _Data(src: url),
          key: key,
        );

  ProfileImage.asset(
    String? assetName, {
    ImageProvider? customImage,
    double radius = 50,
    ImageProvider? errorImage,
    Key? key,
  }) : super(
          isLoading: false,
          config: _Config(
            radius: radius,
            errorImage: errorImage,
          ),
          data: _Data(assetName: assetName),
          key: key,
        );

  ProfileImage.file(
    File? file, {
    ImageProvider? customImage,
    double radius = 50,
    ImageProvider? errorImage,
    Key? key,
  }) : super(
          isLoading: false,
          config: _Config(
            radius: radius,
            errorImage: errorImage,
          ),
          data: _Data(file: file),
          key: key,
        );

  const ProfileImage.loading({
    double radius = 50,
    Key? key,
  }) : super(
          isLoading: true,
          loadingRadius: radius,
          key: key,
        );
}

class _ProfileImageItem extends StatelessWidget {
  const _ProfileImageItem({
    required this.isLoading,
    this.loadingRadius,
    this.data,
    this.config,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final double? loadingRadius;
  final _Data? data;
  final _Config? config;

  void setRadius(double radius) {
    if (config != null) {
      config!.radius = radius;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      assert(
        loadingRadius != null,
        "loadingRadius is required",
      );
    } else {
      assert(
        data != null && config != null,
        "data & config is required",
      );
    }
    return isLoading
        ? _ItemLoading(
            key: key,
            radius: loadingRadius!,
          )
        : _Item(
            config: config!,
            data: data!,
          );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.config,
    required this.data,
    Key? key,
  }) : super(key: key);

  final _Data data;
  final _Config config;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(config.radius / 2),
      child: (data.isEmpty())
          ? _buildError()
          : (data.image != null)
              ? _buildProviderImage(data.image!)
              : (data.file != null)
                  ? _buildProviderImage(FileImage(data.file!))
                  : (data.assetName != null)
                      ? _buildProviderImage(AssetImage(data.assetName!))
                      : _buildNetworkImage(data.src!),
    );
  }

  Widget _buildNetworkImage(String src) {
    return CachedNetworkImage(
      imageUrl: src,
      width: config.radius,
      height: config.radius,
      cacheManager: sl<DefaultCacheManager>(),
      fit: BoxFit.cover,
      placeholder: (context, url) => _ItemLoading(radius: config.radius),
      errorWidget: (context, url, error) => _buildError(),
    );
  }

  Widget _buildProviderImage(ImageProvider image) {
    return Image(
      image: image,
      width: config.radius,
      height: config.radius,
      fit: BoxFit.cover,
      errorBuilder: (context, url, error) => _buildError(),
    );
  }

  Image _buildError() {
    String assetName = ImageRaster.avatar;

    return Image(
      key: const Key("profile_image_error"),
      image: config.errorImage ?? AssetImage(assetName),
      fit: BoxFit.cover,
      height: config.radius,
      width: config.radius,
    );
  }
}

class _ItemLoading extends StatelessWidget {
  const _ItemLoading({this.radius = 50, Key? key}) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      key: const Key("profile_image_loading"),
      height: radius,
      width: radius,
      borderRadius: BorderRadius.circular(radius / 2),
    );
  }
}
