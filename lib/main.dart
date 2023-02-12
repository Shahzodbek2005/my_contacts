import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_contacts/screens/screen_loading.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();  
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.initFlutter();
  await Hive.openBox("boxToken");
  await Hive.openBox("boxEnter");
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: ScreenLoading()));
}
