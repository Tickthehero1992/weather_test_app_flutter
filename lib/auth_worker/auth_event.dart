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

final class AuthForgotGetEvent extends AuthEvent{
   final String email;
   AuthForgotGetEvent({required this.email});
}

final class AuthForgotAskSuccessEvent extends AuthEvent{}

final class AuthForgotAskErrorEvent extends AuthEvent{
   final String error;
   AuthForgotAskErrorEvent({required this.error});
}

final class AuthRegisterEvent extends AuthEvent{}

final class AuthRegisterTryEvent extends AuthEvent{
   late String email;
   late String login;
   late String password;
   AuthRegisterTryEvent({required this.email, required this.login, required this.password});
}

final class AuthRegisterSuccessEvent extends AuthEvent{}

final class AuthRegisterErrorEvent extends AuthEvent{
   final String error;
   AuthRegisterErrorEvent({required this.error});
}

final class AuthSuccessEvent extends AuthEvent {}

final class AuthFailedEvent extends AuthEvent {
   final String error;
   AuthFailedEvent({required this.error});
}

final class AuthBlocEvent extends AuthEvent{}