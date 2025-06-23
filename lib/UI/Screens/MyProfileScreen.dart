import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/createProfileCubit.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/UI/Screens/createPostScreen.dart';
import 'package:instagram/UI/Screens/createStoryScreen.dart';
import 'package:instagram/UI/Screens/profileEditScreen.dart';
import 'package:instagram/UI/Screens/settingsScreen.dart';
import 'package:instagram/UI/Widgets/highlightsWidget.dart';
import 'package:instagram/UI/Widgets/numbersWidget.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileScreen extends StatefulWidget {
  final UserData userData;
  final File? pickedImage;
  final SupabaseClient supabase;

  MyProfileScreen({
    Key? key,
    required this.userData,
    required this.pickedImage,
    required this.supabase,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.userData.username,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 100, 100, 100),
                            items: [
                              PopupMenuItem<String>(
                                value: 'create_post',
                                child: Row(
                                  children: [
                                    Icon(Icons.add_a_photo),
                                    SizedBox(width: 8),
                                    Text('Create Post'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'create_story',
                                child: Row(
                                  children: [
                                    Icon(Icons.camera_alt),
                                    SizedBox(width: 8),
                                    Text('Create Story'),
                                  ],
                                ),
                              )
                            ],
                          ).then((value) {
                            if (value == 'create_post') {
                              Navigator.push(context,  MaterialPageRoute(
                                builder: (context) => BlocProvider<CreateProfileCubit>(
                                  create: (context) => CreateProfileCubit(),
                                  child: createPostScreen(supabase: widget.supabase, userData: widget.userData, pickedImage: widget.pickedImage,),
                                ),
                              ),
                              );
                            } else if (value == 'create_story') {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>createStoryScreen()));
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.add_box_outlined,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>settingsScreen()));
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundImage: widget.userData.profile_photo != null
                            ? NetworkImage(widget.userData.profile_photo!)
                            : const AssetImage("assets/default pic.jpg"),
                        radius: 50,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            numbersWidget('0', 'Posts'),
                            numbersWidget('0', 'Followers'),
                            numbersWidget('0', 'Following'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.userData.name}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        children: [
                          if (widget.userData.bio != null)
                            Text("${widget.userData.bio}")
                          else
                            const SizedBox(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 340,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: colorsManager.greyColor,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => profileEditScreen(
                                        userData: widget.userData,
                                        supabase: widget.supabase,
                                      ),
                                    ),
                                  );
                                },
                                child:  Center(child: Text('Edit Profile',
                                style: TextStyle(
                                  color: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.black,
                                ),)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) => highlightsWidget(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Container(
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.camera_alt_outlined,size: 80,),
                                Text("No Posts Yet",style: TextStyle(fontSize: 40,)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
    );
  }
}