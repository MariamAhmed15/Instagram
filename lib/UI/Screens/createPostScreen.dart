import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Data/postModel.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/createProfileCubit.dart';
import 'package:instagram/Logic/Cubit/postCubit.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/Logic/State/postState.dart';
import 'package:instagram/UI/Screens/newsFeedScreen.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class createPostScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;
  final void Function(Post)? onPostCreated;

  createPostScreen({super.key,
    required this.supabase,
    required this.pickedImage,
    required this.userData,
    this.onPostCreated,

  });

  @override
  State<createPostScreen> createState() => _createPostScreenState();
}

class _createPostScreenState extends State<createPostScreen> {
  TextEditingController descriptionController = TextEditingController();
  File? selectedImage;
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocProvider<postCubit>(
      create: (_) => postCubit(widget.supabase, imagePicker),
      child: BlocConsumer<postCubit, postStates>(
        listener: (context, state) {
          if (state is postLoadingState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is postSuccessState) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post Uploaded Successfully!")),
            );


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => newsFeedScreen(
                  pickedImage: widget.pickedImage,
                  supabase: widget.supabase,
                  userData: widget.userData,
                ),
              ),
            );
          } else if (state is postErrorState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<postCubit>();
          var profileCubit = context.read<CreateProfileCubit>();

          return Scaffold(
            backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
            appBar: AppBar(title: Text("Create Post",
            style: TextStyle(
                color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black),

            ),),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: InkWell(
                          onTap: () async {
                            final image = await cubit.pickImage();
                            if (image != null) {
                              setState(() {
                                selectedImage = File(image.path);
                              });
                            }
                          },
                          child: selectedImage != null
                              ? Image.file(selectedImage!, fit: BoxFit.cover)
                              : const Center(
                                child: Icon(Icons.add_a_photo, size: 50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Write Your Caption Here",
                        hintStyle: TextStyle(
                          color:themeProvider.themeMode == ThemeMode.dark ? Colors.grey: Color.fromRGBO(60, 60, 67, 0.29),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colorsManager.blueColor,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(60, 60, 67, 0.29),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    InkWell(
                      onTap: () async {
                        final description = descriptionController.text;
                        final username = profileCubit.userData.username;
                        final profImage = profileCubit.userData.profile_photo ?? "";

                        if (selectedImage != null) {
                          await cubit.uploadImageAndCreatePost(
                            image: selectedImage!,
                            description: description,
                            username: username,
                            profImage: profImage,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select an image first")),
                          );
                        }
                      },
                      child: Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorsManager.blueColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Post To Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
