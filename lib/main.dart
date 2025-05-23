import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepnote/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const KeepNote()));
}
