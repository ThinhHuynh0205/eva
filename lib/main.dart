import 'package:eva/manager/screens/entryPoint/entry_point_Manager.dart';
import 'package:eva/users/screens/entryPoint/entry_point.dart';
import 'package:eva/users/screens/onboding/onboding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? savedUid = prefs.getString('uid');

  Widget initialScreen;

  if (savedUid != null) {
    if (savedUid == 'VJgu42Q1HTMKV2n7wROPrc4YPgZ2'){
      initialScreen = const EntryPointManager();
    }else {
      initialScreen = const EntryPoint();
    }
  } else {
    initialScreen = const OnbodingScreen();
  }

  runApp(MyApp(initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp(this.initialScreen, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Flutter Way',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      home: initialScreen,
    );
  }
}
const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
