import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';

import './main/factories/factories.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4Dev',
      theme: makeAppTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: makeLoginPage,
        )
      ],
    );
  }
}
