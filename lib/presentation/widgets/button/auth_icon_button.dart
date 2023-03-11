/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Feb 13 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/core.dart';

class AuthIconButton extends StatelessWidget {
  const AuthIconButton({
    required this.type,
    this.ontap,
    super.key,
  });

  final AuthMethod type;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        color: Colors.transparent,
        child:
            type == AuthMethod.apple ? _buildIconApple() : _buildIconGoogle(),
      ),
    );
  }

  Widget _buildIconGoogle() {
    return CircleAvatar(
      key: const Key("auth_icon_google"),
      radius: 18,
      backgroundColor: Colors.white,
      child: Image.asset(
        ImageRaster.googleLogo,
        width: 18,
      ),
    );
  }

  Widget _buildIconApple() {
    return const CircleAvatar(
      key: Key("auth_icon_apple"),
      backgroundColor: Colors.white,
      radius: 18,
      child: Icon(
        FontAwesomeIcons.apple,
        color: Colors.black,
        size: 18,
      ),
    );
  }
}
