// Import the necessary packages
import 'package:firebase_core/firebase_core.dart'; // Firebase Core package for Firebase initialization
import 'package:flutter/material.dart'; // Flutter Material Design package for building the UI
import 'package:sessionchat/Pages/chat_page.dart'; // Import the ChatPage widget
import 'package:sessionchat/Pages/homepage.dart'; // Import the Homepage widget
import 'package:sessionchat/Pages/login_page.dart'; // Import the LoginPage widget
import 'package:sessionchat/Pages/register_page.dart'; // Import the RegisterPage widget
import 'package:sessionchat/Services/log_check.dart'; // Import the LogCheck service
import 'package:sessionchat/Utils/themedata.dart'; // Import the theme data
import 'package:sessionchat/firebase_options.dart'; // Import the Firebase options

// The main function is the entry point of the application
void main() async {
  // Ensure that the Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the current platform's options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the MyApp widget as the root of the application
  runApp(const MyApp());
}

// The MyApp widget is the root of the application
class MyApp extends StatelessWidget {
  // The constructor for the MyApp widget
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp widget as the root of the application
    return MaterialApp(
      // Set the title of the application
      title: 'Sessions',

      // Set the theme of the application
      theme: theme,

      // Set the home page of the application
      home: const AuthVerify(),

      // Define the routes for the application
      routes: {
        // The '/login' route
        '/login': (context) => LoginPage(),

        // The '/register' route
        '/register': (context) => RegisterPage(),

        // The '/home' route
        '/home': (context) => const Homepage(),

        // The '/chat' route
        '/chat': (context) => const ChatPage()
      },
    );
  }
}
