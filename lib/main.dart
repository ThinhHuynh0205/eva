import 'package:eva/users/screens/entryPoint/entry_point.dart';
import 'package:eva/users/screens/onboding/onboding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  BuildContext? myContext;
  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user != null) {
      // Sử dụng biến myContext để push Navigator
      if (myContext != null) {
        Navigator.push(
          myContext!,
          MaterialPageRoute(
            builder: (context) => const EntryPoint(),
          ),
        );
      }
    }
  });
  runApp(MyApp(myContext));
}

class MyApp extends StatelessWidget {
  const MyApp(this.myContext, {super.key});

  final BuildContext? myContext;

  // This widget is the root of your application.
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
      home: const OnbodingScreen(),
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
