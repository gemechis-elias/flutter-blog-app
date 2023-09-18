import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getAllArticles();
  Future<Either<Failure, List<Article>>> getAllBookmarks();
  Future<Either<Failure, Article>> getSingleArticle(String articleId);
  Future<Either<Failure, List<Article>>> searchArticle(String tag, String key);

  Future<Either<Failure, void>> updateArticle(Article article);
  Future<Either<Failure, Article>> createArticle({
    required String title,
    required String content,
    required String subTitle,
    required File image,
    required String tags,
  });
  Future<Either<Failure, Article>> deleteArticle(String articleId);
  Future<Either<Failure, List<String>>> getTags();
  Future<Either<Failure, Article>> addBookmark({
    required String title,
    required String content,
    required String subTitle,
    required File image,
    required String tags,
  });
}
