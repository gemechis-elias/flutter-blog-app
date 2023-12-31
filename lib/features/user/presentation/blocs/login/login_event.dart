import 'package:blog_app/features/user/presentation/blocs/bloc_event.dart';

class LoginUserEvent extends UserEvent {
  final String email;
  final String password;

  const LoginUserEvent({
    required this.email,
    required this.password,
  });
}
