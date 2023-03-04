/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:equatable/equatable.dart';
import '../../core/core.dart';

class URLImage extends Equatable {
  final String? small;
  final String? medium;
  final String? large;
  final String? original;

  const URLImage({
    this.small,
    this.original,
    this.medium,
    this.large,
  });

  factory URLImage.fromMap(Map<String, dynamic> map) {
    return URLImage(
      original: Parser.getString(map["original"]),
      small: Parser.getString(map["small"]),
      medium: Parser.getString(map["medium"]),
      large: Parser.getString(map["large"]),
    );
  }

  /// returns usable images in the order:
  /// * small
  /// * medium
  /// * large
  /// * original
  ///
  String? get fixed => small ?? medium ?? large ?? original;

  @override
  List<Object?> get props => [
        small,
        medium,
        large,
        original,
      ];
}
