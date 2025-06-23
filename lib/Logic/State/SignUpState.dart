class signUpStates{}
class signUpInitialState extends signUpStates{}
class signUpLoadingState extends signUpStates{}
class signUpSuccessState extends signUpStates{}
class signUpErrorState extends signUpStates{
  String errorMessage;
  signUpErrorState(this.errorMessage);
}
