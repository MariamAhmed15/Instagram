import 'package:instagram/Data/userModel.dart';

class createProfileStates {}
class createProfileInitialState extends createProfileStates{}
class createProfileLoadingState extends createProfileStates{}
class createProfileSuccessState extends createProfileStates{
  final UserData userData;
  createProfileSuccessState(this.userData);
}
class createProfileErrorState extends createProfileStates{
  String errorMessage;
  createProfileErrorState(this.errorMessage);
}