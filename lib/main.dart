import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/login_page.dart';
import 'package:sessionchat/Pages/register_page.dart';
import 'package:sessionchat/Utils/themedata.dart';
import 'package:sessionchat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
