import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sessionchat/Pages/chat_page.dart';
import 'package:sessionchat/Pages/homepage.dart';
import 'package:sessionchat/Pages/login_page.dart';
import 'package:sessionchat/Pages/register_page.dart';
import 'package:sessionchat/Services/log_check.dart';
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
      title: 'Sessions',
      theme: theme,
      home: const AuthVerify(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => const Homepage(),
        '/chat': (context) => const ChatPage()
      },
    );
  }
}
