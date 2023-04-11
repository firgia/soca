/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CallBackgroundImage extends StatelessWidget {
  const CallBackgroundImage({
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .2,
      child: CachedNetworkImage(
        imageUrl: url,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const SizedBox();
        },
      ),
    );
  }
}
