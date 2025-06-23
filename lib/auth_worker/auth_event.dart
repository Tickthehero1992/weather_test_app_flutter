part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthInitEvent extends AuthEvent{}

final class AuthEnterEvent extends AuthEvent {
   late String login;
   late String password;
   AuthEnterEvent({required this.login, required this.password});
}

final class AuthForgotEvent extends AuthEvent{}

final class AuthForgotAskEvent extends AuthEvent{}

final class AuthForgotAskSuccessEvent extends AuthEvent{}

final class AuthForgotAskErrorEvent extends AuthEvent{}

final class AuthRegisterEvent extends AuthEvent{}

final class AuthRegisterSuccessEvent extends AuthEvent{}

final class AuthRegisterErrorEvent extends AuthEvent{}

final class AuthSuccessEvent extends AuthEvent {}

final class AuthFailedEvent extends AuthEvent {}

final class AuthBlocEvent extends AuthEvent{}