
import 'package:equatable/equatable.dart';
import 'package:instagram/Data/userModel.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<UserData> users;

  const SearchSuccessState(this.users);

  @override
  List<Object?> get props => [users];
}

class SearchErrorState extends SearchState {
  final String errorMessage;

  const SearchErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
