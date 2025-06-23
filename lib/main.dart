import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/UI/Screens/loginScreen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mkkkqfycgfqkgjiylfpz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ra2txZnljZ2Zxa2dqaXlsZnB6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg1ODIzMzIsImV4cCI6MjA1NDE1ODMzMn0._YPugbqB4G6fGUpSW2meFv94iFpkeBAtK2qN22hVUFk',
  );
  // Example user data (replace with real fetching logic)
  UserData userData = UserData(
    id: '123',
    username: 'test_user',
    email: 'test@example.com',
    profile_photo: '',
    followers: 0,
    following: 0,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(userData: userData, pickedImage: null), // Pass userData properly
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserData userData;
  final File? pickedImage;

  const MyApp({Key? key, required this.userData, required this.pickedImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: loginScreen(
        supabase: Supabase.instance.client,
        userData: userData,
        pickedImage: pickedImage,
      ),
    );
  }
}
