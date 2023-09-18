import 'package:blog_app/features/user/domain/entities/user.dart';
import 'package:blog_app/features/user/presentation/blocs/bloc_state.dart';

class ChangingProfileState extends UserState {
  ChangingProfileState();

  @override
  List<Object> get props => [];
}

class ChangedProfileState extends UserState {
  final User user;
  ChangedProfileState(this.user);

  @override
  List<Object> get props => [];
}

class ProfileError extends UserState {
  final String errorMessage;

  ProfileError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
