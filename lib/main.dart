import 'package:flutter/material.dart';
import 'Screens/home.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Widgets/appLocalizations.dart';

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
      supportedLocales: [Locale('en', 'US'), Locale('pt', 'BR')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
      home: MyHomePage(),
    );
  }
}
