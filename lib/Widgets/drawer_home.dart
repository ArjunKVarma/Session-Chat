import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';

class drawerWidget extends StatelessWidget {
  const drawerWidget({super.key});
  void logout(context) {
    final AuthService _auth = AuthService();
    _auth.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          // Important: Remove any padding from the ListView.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text('LogOut'),
                onTap: () {
                  logout(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
