import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Data/postModel.dart';
import 'package:instagram/Logic/State/postState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class postCubit extends Cubit<postStates> {
  final SupabaseClient supabase;
  final ImagePicker imagePicker;

  postCubit(this.supabase, this.imagePicker) : super(postInitialState());

  Future<void> getPosts() async {
    try {
      emit(postLoadingState());
      final response = await supabase.from('posts').select();
      final posts = response.map((map) {
        final post = Post.fromMap(map);
        return post.copyWith(likes: post.likes);
      }).toList();
      emit(postSuccessState(posts));
    } catch (e) {
      emit(postErrorState(e.toString()));
    }
  }

  Future<File?> pickImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      emit(postErrorState(e.toString()));
      return null;
    }
  }

  Future<void> uploadImageAndCreatePost({
    required File image,
    required String description,
    required String username,
    required String profImage,
  }) async {
    try {
      emit(postLoadingState());

      final String postId = const Uuid().v4();
      final String ext = image.path.split('.').last;
      final String path = "posts/$postId.$ext";


      final fileBytes = await image.readAsBytes();
      await supabase.storage.from('posts').uploadBinary(path, fileBytes);


      final String postUrl = supabase.storage.from('posts').getPublicUrl(path);

      final newPost = Post(
        description: description,
        username: username,
        likes: 0,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );

      await supabase.from('posts').insert(newPost.toJson());
      getPosts();
    } catch (e) {
      emit(postErrorState(e.toString()));
    }
  }
}
