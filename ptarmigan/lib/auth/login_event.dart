abstract class LoginEvent {}

class LoginUsernameChanged extends LoginEvent {
  final String username;

  LoginUsernameChanged({required this.username});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {}
