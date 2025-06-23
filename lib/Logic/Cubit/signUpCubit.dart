import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Logic/State/SignUpState.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpCubit extends Cubit<signUpStates> {
  SupabaseClient supabaseClient= Supabase.instance.client;

  SignUpCubit(this.supabaseClient) : super(signUpInitialState());

  Future<AuthResponse> signUp({required String email, required String password}) async {
    emit(signUpLoadingState());
    try {
      final response = await supabaseClient.auth.signUp(email: email, password: password);
      emit(signUpSuccessState());
      return response;
    } catch (e) {
      emit(signUpErrorState(e.toString()));
      throw Exception("Sign-up failed: ${e.toString()}");
    }
  }
}
