import 'package:cal4u/Screens/HomePage.dart';
import 'package:cal4u/Screens/loginPage.dart';
import 'package:cal4u/helpers/StoredPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final value = await SharedPreferences.getInstance();
  storedPrefs = StoredPrefs(value);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cal4U',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.white),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Color.fromRGBO(240, 174, 52, 1),
          primaryColor: Colors.red,
          fontFamily: 'Assistant'),
      home: storedPrefs.accessToken == null ? LoginPage() : HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('he', ''),
        // const Locale('en', ''),
      ],
    );
  }
}
