
abstract class LoginStates{}

class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates {
  final String uid;
  final String group;

  LoginSuccessState(this.uid, this.group); // Add this line
}
class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}


class RegisterInitialState extends LoginStates{}
class RegisterLoadingState extends LoginStates{}
class RegisterSuccessState extends LoginStates {}
class RegisterErrorState extends LoginStates{

}

class SeePassState extends LoginStates{}


class ChangePasswordState extends LoginStates{

}
class LoadingPasswordState extends LoginStates{}
class ErrorPasswordState extends LoginStates{
  final String error;
  ErrorPasswordState(this.error);
}
