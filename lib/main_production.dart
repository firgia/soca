import 'package:flutter/material.dart';
import 'app.dart';
import 'config/config.dart';
import 'core/core.dart';

void main() async {
  Environtment.setCurrentEnvirontment(EnvirontmentType.production);
  await initializeApp();

  runApp(const App(title: "Soca"));
}
