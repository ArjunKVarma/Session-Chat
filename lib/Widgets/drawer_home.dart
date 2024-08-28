// Import the necessary package for building Flutter widgets
import 'package:flutter/material.dart';

// Import the AuthService class from the auth.dart file in the Services directory
import 'package:sessionchat/Services/auth.dart';

// Define a stateless widget named DrawerWidget
class DrawerWidget extends StatelessWidget {
  // Define a constructor for the DrawerWidget with a key parameter
  const DrawerWidget({super.key});

  // Define a method named logout that takes a BuildContext parameter
  void logout(BuildContext context) {
    // Create an instance of the AuthService class
    final AuthService _auth = AuthService();

    // Call the logout method on the AuthService instance
    _auth.logout();

    // Use the Navigator to push a replacement route to the root route ('/')
    // This will replace the current route with the root route, effectively logging out the user
    Navigator.pushReplacementNamed(context, '/');
  }

  // Override the build method to define the layout of the DrawerWidget
  @override
  Widget build(BuildContext context) {
    // Return a Drawer widget
    return Drawer(
      // Set the child property of the Drawer to a Container widget
      child: Container(
        // Set the color property of the Container to the surface color of the current theme
        color: Theme.of(context).colorScheme.surface,

        // Set the child property of the Container to a Column widget
        child: Column(
          // Set the mainAxisAlignment property of the Column to MainAxisAlignment.spaceBetween
          // This will space the children of the Column evenly between the start and end of the Column
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          // Define the children of the Column
          children: [
            // Create a Padding widget with a padding of 15.0 on all sides
            Padding(
              padding: const EdgeInsets.all(15.0),

              // Set the child property of the Padding to a ListTile widget
              child: ListTile(
                // Set the leading property of the ListTile to an Icon widget with the Icons.home icon
                leading: const Icon(Icons.home),

                // Set the title property of the ListTile to a Text widget with the text 'Home'
                title: const Text('Home'),

                // Set the onTap property of the ListTile to a callback that pops the current route
                onTap: () {
                  // Use the Navigator to pop the current route
                  Navigator.pop(context);
                },
              ),
            ),

            // Create a Padding widget with a padding of 15.0 on all sides
            Padding(
              padding: const EdgeInsets.all(15.0),

              // Set the child property of the Padding to a ListTile widget
              child: ListTile(
                // Set the leading property of the ListTile to an Icon widget with the Icons.exit_to_app icon
                leading: const Icon(Icons.exit_to_app),

                // Set the title property of the ListTile to a Text widget with the text 'LogOut'
                title: const Text('LogOut'),

                // Set the onTap property of the ListTile to a callback that calls the logout method
                onTap: () {
                  // Call the logout method with the current BuildContext
                  logout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
