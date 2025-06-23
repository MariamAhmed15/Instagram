import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/storyModel.dart';
import 'package:instagram/Logic/State/storyState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryInitialState());

  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Future<void> getStories() async {
    try {
      emit(StoryLoadingState());

      final response = await supabase
          .from('stories')
          .select()
          .order('created_at', ascending: false);

      final stories = response.map<Story>((data) => Story.fromJson(data)).toList();
      emit(StorySuccessState(stories));
    } catch (e) {
      emit(StoryErrorState("Failed to fetch stories: $e"));
    }
  }


  Future<void> uploadStory() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      emit(StoryLoadingState());

      final File file = File(image.path);
      final String filePath = 'stories/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('stories').upload(filePath, file);
      final String imageUrl = supabase.storage.from('stories').getPublicUrl(filePath);

      final String? userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception("User not logged in");

      await supabase.from('stories').insert({
        'user_id': userId,
        'image_url': imageUrl,
        'duration': 5,
        'created_at': DateTime.now().toIso8601String(),
      });

      getStories();
    } catch (e) {
      emit(StoryErrorState("Error uploading story: $e"));
    }
  }

  void listenForStories() {
    supabase
        .from('stories')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .listen((data) {
      final stories = data.map<Story>((json) => Story.fromJson(json)).toList();
      emit(StorySuccessState(stories));
    });
  }
}
