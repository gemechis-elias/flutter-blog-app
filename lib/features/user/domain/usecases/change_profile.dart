import 'dart:io';
import 'package:blog_app/features/user/domain/entities/user.dart';
import 'package:blog_app/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class ChangeProfileUseCase {
  final UserRepository repository;

  ChangeProfileUseCase(this.repository);

  Future<Either<Failure, User>> call(ProfilePicParams params) async {
    //  return await repository.createArticle(article);
    try {
      final user = await repository.updateProfilePhoto(params.image);
      print("change profile usecase ${params.image}");

      return Right(user as User);

      // Return success as Right with null value
    } catch (e) {
      return const Left(ServerFailure('Error changing profile'));
    }
  }
}

class ProfilePicParams {
  final File image;

  ProfilePicParams({
    required this.image,
  });
}
