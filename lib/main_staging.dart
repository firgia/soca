/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'app.dart';
import 'config/config.dart';
import 'core/core.dart';

void main() async {
  Environtment.setCurrentEnvirontment(EnvirontmentType.staging);
  await initializeApp();

  runApp(const App(title: "Soca - Staging"));
}
