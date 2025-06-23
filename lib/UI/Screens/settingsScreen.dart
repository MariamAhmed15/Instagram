import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/UI/Screens/loginScreen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class settingsScreen extends StatelessWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;
  const settingsScreen({super.key,required this.pickedImage, required this.supabase, required this.userData});


  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.only(top:300),
        child: Column(
          children: [
            Row(
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
            SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                final supabase = Supabase.instance.client;

                await supabase.auth.signOut();
                print(" Logged out successfully");

                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>loginScreen(supabase:supabase, pickedImage: pickedImage, userData: userData)));

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Log Out"),
                  SizedBox(width: 7,),
                  Icon(Icons.logout),
                ],
              ),
            )
          ]

        ),
      ),
    );
  }
}
