import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/article.dart';
import '../repositories/article_repository.dart';

class AddBookmarkUseCase {
  final ArticleRepository repository;

  AddBookmarkUseCase(this.repository);

  Future<Either<Failure, Article>> call(AddBookmarkParams params) async {
    print("add bookmark usecase");
    //  return await repository.createArticle(article);
    try {
      final article = await repository.addBookmark(
        title: params.title,
        content: params.content,
        subTitle: params.subTitle,
        image: params.image,
        tags: params.tagList,
      );
      log("Usecase Bookmaek created $article");
      return article; // Return success as Right with null value
    } catch (e) {
      return const Left(ServerFailure('Error creating article'));
    }
  }
}

class AddBookmarkParams {
  final String title;
  final String content;
  final String subTitle;
  final File image;
  final String tagList;

  AddBookmarkParams({
    required this.title,
    required this.content,
    required this.subTitle,
    required this.image,
    required this.tagList,
  });
}
