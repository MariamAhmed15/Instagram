import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Logic/State/loginState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class loginCubit extends Cubit<loginStates> {
  final SupabaseClient supabaseClient;

  loginCubit(this.supabaseClient) : super(loginInitialState());

  Future<AuthResponse> login({required String email, required String password}) async {
    emit(loginLoadingState());
    try {
      final response = await supabaseClient.auth.signInWithPassword(password: password, email: email);
      emit(loginSuccessState());
      return response;
    } catch (e) {
      emit(loginErrorState(e.toString()));
      throw Exception("Log-in failed: ${e.toString()}");
    }
  }
}
