import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/user/domain/entities/user.dart';
import 'package:blog_app/features/user/domain/usecases/change_profile.dart';
import 'package:blog_app/features/user/domain/usecases/get_user.dart';
import 'package:blog_app/features/user/domain/usecases/login_user.dart';
import 'package:blog_app/features/user/domain/usecases/register_user.dart';
import 'package:blog_app/features/user/domain/usecases/update_user.dart';
import 'package:blog_app/features/user/presentation/blocs/bloc_state.dart';
import 'package:blog_app/features/user/presentation/blocs/bloc_event.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/change_profile_pic/profile_pic_event.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/change_profile_pic/profile_pic_state.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/user_event.dart';
import 'package:blog_app/features/user/presentation/blocs/get_user.dart/user_state.dart';
import 'package:blog_app/features/user/presentation/blocs/login/login_event.dart';
import 'package:blog_app/features/user/presentation/blocs/login/login_state.dart';
import 'package:blog_app/features/user/presentation/blocs/singup/signup_event.dart';
import 'package:blog_app/features/user/presentation/blocs/singup/signup_state.dart';
import 'package:dartz/dartz.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final RegisterUserUseCase registerUser;
  final LoginUserUseCase loginUser;
  final GetUserUseCase getUser;
  final ChangeProfileUseCase updateProfilePhoto;

  UserBloc({
    required this.registerUser,
    required this.loginUser,
    required this.getUser,
    required this.updateProfilePhoto,
  }) : super(UserInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final Either<Failure, User> result =
            await registerUser(RegisterUserParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          expertise: event.expertise,
          bio: event.bio,
        ));

        // emit UserSignedInState
        emit(result.fold(
          (failure) => UserError(_mapFailureToMessage(failure)),
          (user) => UserSignedInState(user),
        ));
      } catch (e) {
        emit(const UserError('Error registering user'));
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(UserLoading()); // Emit UserLoading state here

      try {
        final Either<Failure, User> result = await loginUser(
          email: event.email,
          password: event.password,
        );
        emit(result.fold(
          (failure) => UserError(_mapFailureToMessage(failure)),
          (user) => LoadedUserState(user),
        ));
      } catch (e) {
        emit(UserError(
            _mapFailureToMessage(const ServerFailure('Error logging in'))));
      }
    });

    on<GetUserEvent>((event, emit) async {
      emit(UserLoading()); // Emit UserLoading state here

      try {
        final Either<Failure, User> result = await getUser();
        log("User fetched on bloc $result");
        emit(result.fold(
          (failure) => UserError(_mapFailureToMessage(failure)),
          (user) => LoadedGetUserState(user),
        ));
      } catch (e) {
        emit(UserError(
            _mapFailureToMessage(const ServerFailure('Error fetching user'))));
      }
    });
    on<ChangeProfileEvent>((event, emit) async {
      try {
        emit(ChangingProfileState());
        print('changing profile - STARTED');

        // Call updateProfilePhoto without expecting a result
        final result =
            await updateProfilePhoto(ProfilePicParams(image: event.image));

        emit(
          result.fold((failure) => ProfileError(_mapFailureToMessage(failure)),
              (user) => ChangedProfileState(user)),
        );

        print("Finished processing - in the bloc ${event.image}");
      } catch (e) {
        emit(ProfileError('Error updating profile photo'));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    return 'An Bloc error occurred $failure';
  }
}
