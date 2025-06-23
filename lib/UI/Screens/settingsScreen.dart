import 'package:flutter/material.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:provider/provider.dart';

class settingsScreen extends StatelessWidget {
  const settingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                themeProvider.toggleTheme();
              },
              child: Row(
                children: [
                  Text(themeProvider.themeMode == ThemeMode.dark
                      ? "Switch to Light Mode"
                      : "Switch to Dark Mode"),
                  SizedBox(width: 10,),
                  Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
