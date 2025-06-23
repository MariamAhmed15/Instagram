import 'package:instagram/Data/postModel.dart';

class postStates{}
  class postInitialState extends postStates{}
  class postLoadingState extends postStates{}
  class postSuccessState extends postStates{
    final List<Post> posts;
    postSuccessState(this.posts);
  }
  class postErrorState extends postStates{
  String errorMessage;
  postErrorState(this.errorMessage);
  }
