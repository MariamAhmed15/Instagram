import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/State/searchState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchCubit extends Cubit<SearchState> {
  final SupabaseClient supabase;
  final Dio dio;

  SearchCubit({required this.supabase})
      : dio = Dio(),
        super(SearchInitialState());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(const SearchSuccessState([]));
      return;
    }

    try {
      emit(SearchLoadingState());

      final currentUserId = supabase.auth.currentUser?.id ?? '';

      final response = await supabase
          .from('profiles')
          .select('id, username, name, profile_photo, gender, followers, following, email, website, phone, bio')
          .ilike('username', '%$query%')
          .not('id', 'eq', currentUserId.isNotEmpty ? currentUserId : 'NULL_ID')
          .order('username')
          .limit(20);

      final users = (response as List).map((user) {
        return UserData(
          id: user['id'] as String? ?? '',
          username: user['username'] as String? ?? 'Unknown',
          name: user['name'] as String? ?? '',
          profile_photo: user['profile_photo'] as String?,
          gender: user['gender'] as String? ?? 'Other',
          followers: (user['followers'] ?? 0) as int,
          following: (user['following'] ?? 0) as int,
          email: user['email'] as String? ?? '',
          website: user['website'] as String? ?? '',
          phone: user['phone'] as String? ?? '',
          bio: user['bio'] as String? ?? '',
        );
      }).toList();

      emit(SearchSuccessState(users));
    } catch (e) {
      emit(SearchErrorState('No Users Found'));
    }
  }
}