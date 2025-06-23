import 'package:equatable/equatable.dart';
import 'package:instagram/Data/storyModel.dart';

abstract class StoryState extends Equatable {
  const StoryState();

  @override
  List<Object> get props => [];
}

class StoryInitialState extends StoryState {}

class StoryLoadingState extends StoryState {}

class StorySuccessState extends StoryState {
  final List<Story> stories;
  const StorySuccessState(this.stories);

  @override
  List<Object> get props => [stories];
}

class StoryErrorState extends StoryState {
  final String errorMessage;
  const StoryErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
