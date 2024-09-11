import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:remindits/Screen/home_screen.dart';
import 'package:remindits/Screen/login_screen.dart';
import 'package:remindits/firebase_options.dart';
import 'package:remindits/widgets/artickle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RemindIT",
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? HomePage() : LoginPage(),
    );
  }
}
