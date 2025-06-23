class loginStates{}
class loginInitialState extends loginStates{}
class loginLoadingState extends loginStates{}
class loginSuccessState extends loginStates{}
class loginErrorState extends loginStates{
  String errorMessage;
  loginErrorState(this.errorMessage);
}