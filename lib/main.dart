import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'package:device_preview/device_preview.dart';

// void main() {
//   runApp(MyApp());
// }

void main() => runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Finder',
      theme: ThemeData(
        primaryColor: Color(0xFF5900b3),
        primaryColorDark: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
      home: MyHomePage(),
    );
  }
}
