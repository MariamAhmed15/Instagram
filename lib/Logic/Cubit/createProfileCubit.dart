import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/State/createProfileState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateProfileCubit extends Cubit<createProfileStates> {
  CreateProfileCubit() : super(createProfileInitialState());
  File? pickedImage;
  UserData userData = UserData(
    id: '',
    name: '',
    username: '',
    website: '',
    bio: '',
    email: '',
    phone: '',
    gender: '',
    profile_photo: '',
    followers: 0,
    following: 0,
  );

  final SupabaseClient supabase = Supabase.instance.client;

  void saveProfileData(
      String name,
      String username,
      String website,
      String bio,
      String email,
      String phone,
      String gender,
      ) async {
    try {
      final userId = supabase.auth.currentUser?.id ?? '';
      userData = UserData(
        id: userId,
        name: name,
        username: username,
        website: website,
        bio: bio,
        email: email,
        phone: phone,
        gender: gender,
        profile_photo: pickedImage?.path ?? '',
        followers: 0,
        following: 0,
      );

      await supabase.from('profiles').upsert({
        'id': userData.id,
        'name': userData.name,
        'username': userData.username,
        'website': userData.website,
        'bio': userData.bio,
        'email': userData.email,
        'phone': userData.phone,
        'gender': userData.gender,
        'profile_photo': userData.profile_photo,
        'followers': userData.followers,
        'following': userData.following,
      });

      emit(createProfileSuccessState(userData));
    } catch (e) {
      emit(createProfileErrorState(e.toString()));
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      userData.profile_photo = pickedFile.path;
      emit(createProfileSuccessState(userData));
    } else {
      emit(createProfileErrorState("No image selected"));
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    emit(createProfileLoadingState());

    try {
      if (pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No image selected")),
        );
        emit(createProfileErrorState("No image selected"));
        return;
      }

      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = "uploads/$fileName";

      await supabase.storage
          .from("profile picture upload")
          .upload(path, pickedImage!);

      final imageUrl = supabase.storage
          .from("profile picture upload")
          .getPublicUrl(path);

      userData.profile_photo = imageUrl;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image Uploaded")),
      );
      emit(createProfileSuccessState(userData));
    } catch (e) {
      emit(createProfileErrorState(e.toString()));
    }
  }
}
