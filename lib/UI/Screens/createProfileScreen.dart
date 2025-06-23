import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/createProfileCubit.dart';
import 'package:instagram/Logic/State/createProfileState.dart';
import 'package:instagram/UI/Screens/newsFeedScreen.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateProfileScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;
  CreateProfileScreen({super.key, required this.supabase, required this.userData , required this.pickedImage});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 130),
                        Text(
                          "Create Profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
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
                                      child: newsFeedScreen(supabase: widget.supabase, pickedImage: widget.pickedImage, userData: widget.userData,)
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
                child:Text(
              "Add Profile Photo",
              style: TextStyle(
                color: colorsManager.blueColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
              onPressed: ()async {
                await cubit.pickImage(); // Pick image
                if (cubit.pickedImage != null) {
                  await cubit.uploadImage(context); // Upload image
                }
              },



            )
              ,

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                    width: 50
                ),
                Container(
                width: 279,
                height: 48,
                child: TextFormField(
                controller: nameController,
                decoration:InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(
                color:Color.fromRGBO(60, 60, 67, 0.29),
                ),
                focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                color: colorsManager.blueColor,
                )
                ),
                enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                color:Color.fromRGBO(60, 60, 67, 0.29),
                ),
                )
                )
                ),
                ),
              ],
            ),
          ),


              Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Row(
          children: [
          Text(
          "Username",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(
          width: 14
          ),
          Container(
          width: 275,
          height: 48,
          child: TextFormField(
          controller: usernameController,
          decoration:InputDecoration(
          hintText: "Username",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ),
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Row(
          children: [
          Text(
          "Website",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(width: 27,),
          Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: websiteController,
          decoration:InputDecoration(
          hintText: "Website",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ),
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Row(
          children: [
          Text(
          "Bio",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(width: 60,),
          Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: bioController,
          decoration:InputDecoration(
          hintText: "Bio",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ),
          ),
          ],
          ),
          ),
          SizedBox(
          height: 10,
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
          child: Row(
          children: [
          Text(
          "Email",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(width: 35,),
          Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: emailController,
          decoration:InputDecoration(
          hintText: "Email",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ),
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Row(
          children: [
          Text(
          "Phone",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(width: 30,),
          Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: phoneController,
          decoration:InputDecoration(
          hintText: "Phone",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ),
          ),
          ],
          ),
          ),
          Padding(
          padding: const EdgeInsets.only(
          left: 8.0
          ),
          child: Row(
          children: [
          Text(
          "Gender",
          style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          ),
          ),
          SizedBox(
          width: 25,
          ),
          Container(
          width: 279,
          height: 48,
          child: TextFormField(
          controller: genderController,
          decoration:InputDecoration(
          hintText: "Gender",
          hintStyle: TextStyle(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color: colorsManager.blueColor,
          )
          ),
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
          color:Color.fromRGBO(60, 60, 67, 0.29),
          ),
          )
          )
          ))],
              ),
            ),
              ]),),
          );
        },
      ),
    );
  }

  bool allFieldsAreFilled() {
    return nameController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        genderController.text.isNotEmpty;
  }
}
