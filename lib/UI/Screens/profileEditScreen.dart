import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/createProfileCubit.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/Logic/State/createProfileState.dart';
import 'package:instagram/UI/Screens/MyProfileScreen.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class profileEditScreen extends StatefulWidget {
  final UserData userData;
  final SupabaseClient supabase;

  profileEditScreen({super.key, required this.userData, required this.supabase});

  @override
  State<profileEditScreen> createState() => _createProfileScreenState();
}

class _createProfileScreenState extends State<profileEditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userData.name ?? '';
    usernameController.text = widget.userData.username ;
    websiteController.text = widget.userData.website ?? '';
    bioController.text = widget.userData.bio ?? '';
    emailController.text = widget.userData.email ?? '';
    phoneController.text = widget.userData.phone ?? '';
    genderController.text = widget.userData.gender ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocProvider(
      create: (_) => CreateProfileCubit(),
      child: BlocConsumer<CreateProfileCubit, createProfileStates>(
        listener: (context, state) {
          if (state is createProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is createProfileSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Saved Successfully!")));
          }
        },
        builder: (context, state) {
          var cubit = context.read<CreateProfileCubit>();
          return Scaffold(
            backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyProfileScreen(userData: cubit.userData, pickedImage: cubit.pickedImage,supabase: widget.supabase,)),
                            );
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 15,
                            color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            if (allFieldsAreFilled()) {
                              cubit.saveProfileData(
                                nameController.text,
                                usernameController.text,
                                websiteController.text,
                                bioController.text,
                                emailController.text,
                                phoneController.text,
                                genderController.text,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cubit,
                                    child: MyProfileScreen(userData: cubit.userData, pickedImage: cubit.pickedImage,supabase: widget.supabase,),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all the fields")));
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: colorsManager.blueColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: cubit.userData.profile_photo != null
                        ? FileImage(File(cubit.userData.profile_photo!))
                        : const AssetImage("assets/default pic.jpg"),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: ()async {
                      await cubit.pickImage(); // Pick image
                      if (cubit.pickedImage != null) {
                        await cubit.uploadImage(context); // Upload image
                      }
                    },
                    child: Text("Add Profile Photo",
                    style: TextStyle(
                      color: colorsManager.blueColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),)
                  ),
                  SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child:
                Container(
                width: 279,
                height: 48,
                child: TextFormField(
                controller: nameController,
                decoration:InputDecoration(
                  labelText: "Name",
                labelStyle: TextStyle(
                  color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
                ),
                hintText: "Enter Your Name",
                    hintStyle: TextStyle(
                      color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
                    ),
                focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                color: colorsManager.blueColor,
                )
                ),
                enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
                ),
                )
                )
                ),
                ),

          ),

          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child:
          Container(
          width: 275,
          height: 48,
          child: TextFormField(
          controller: usernameController,
          decoration:InputDecoration(
            labelText: "Username",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Username",
              hintStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ),
          ),

          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: websiteController,
          decoration:InputDecoration(
            labelText: "Website",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Website",

              hintStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ),
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: bioController,
          decoration:InputDecoration(
            labelText: "Bio",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Bio",
              hintStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ),
          ),
          ),

          SizedBox(height: 40),
          Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text(
          "Private Information",
          style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          ),
          ),
          ],
          ),
          ),
          SizedBox(
          height: 16,
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: emailController,
          decoration:InputDecoration(
            labelText: "Email",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Email",
            hintStyle: TextStyle(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
            ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ),
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: phoneController,
          decoration:InputDecoration(
            labelText: "Phone",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Phone",
              hintStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ),
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: genderController,
          decoration:InputDecoration(
            labelText: "Gender",
              labelStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          hintText: "Enter Your Gender",
              hintStyle: TextStyle(
                color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
              ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:themeProvider.themeMode == ThemeMode.dark ? Colors.white : Color.fromRGBO(60, 60, 67, 0.29),
            ),
          )
          )
          ))
            ),
                ],
          ),
          ),
          );
        },
      ),
    );
  }
  bool allFieldsAreFilled() {
    return nameController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty;
  }
}
