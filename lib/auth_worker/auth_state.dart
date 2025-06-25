part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitState extends AuthState{}

final class AuthForgotState extends AuthState{}

final class AuthForgotSuccessState extends AuthState{}

final class AuthForgotErrorState extends AuthState{
  final String error;
  AuthForgotErrorState({required this.error});
}

final class AuthRegisterState extends AuthState{}

final class AuthRegisterSuccessState extends AuthState{}

final class AuthRegisterErrorState extends AuthState{
  final String error;
  AuthRegisterErrorState({required this.error});
}

final class AuthEnterState extends AuthState{}

final class AuthSuccessState extends AuthState{}

final class AuthFailedState extends AuthState{
  final String error;
  AuthFailedState({required this.error});
}

final class AuthBlocState extends AuthState{}



