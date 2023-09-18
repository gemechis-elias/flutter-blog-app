import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:dartz/dartz.dart';

abstract class BlogRemoteDataSource {
  Future<List<Article>> getAllBlog();
  Future<Map<String, dynamic>> postBlog(Map<String, dynamic> blogData);

  Future<List<Article>> searchArticle(String tag, String key);
  // get tags
  Future<List<String>> getTags();
  Future<dynamic> deleteArticle(String articleId);
}

abstract class BlogLocalDataSource {
  Future<Either<Failure, List<Article>>> getAllArticles();
  Future<Either<Failure, List<Article>>> getAllBookmarks();
  Future<Either<Failure, void>> createArticle(Article article);
  Future<Map<String, dynamic>> deleteArticle(String articleId);
  Future<List<Article>> searchArticle(String tag, String key);
  Future<Either<Failure, Article>> getAllArticle(String tags);
  Future<Either<Failure, Article>> getSingleArticle(String articleId);
  Future<List<String>> getTags();
  Future<Either<Failure, void>> addBookmark(Map<String, dynamic> blogData);
}
