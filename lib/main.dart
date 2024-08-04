import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:steal_client/models/config_model.dart';

import 'package:steal_client/pages/home_page.dart';

Future<void> main() async {
  // Setup initializers
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ConfigModelAdapter());
  await Hive.openBox<ConfigModel>("configs");

  runApp(
    const GetMaterialApp(
      title: "Steal Client",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}
