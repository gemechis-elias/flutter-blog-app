import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/data/datasources/data_source_api.dart';
import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogLocalDataSourceImp implements BlogLocalDataSource {
  static const String _bookmarkKey = 'bookmarked_blogs';
  final SharedPreferences sharedPreferences;

  BlogLocalDataSourceImp({required this.sharedPreferences});

  Future<Either<Failure, void>> addBookmark(
      Map<String, dynamic> blogData) async {
    try {
      // Get the existing list of bookmarked blogs from SharedPreferences
      final List<String>? bookmarkedBlogsJson =
          sharedPreferences.getStringList(_bookmarkKey);

      // Convert the existing JSON list to a List<Map<String, dynamic>>
      final List<Map<String, dynamic>> bookmarkedBlogs = bookmarkedBlogsJson
              ?.map((e) => Map<String, dynamic>.from(json.decode(e)))
              ?.toList() ??
          [];

      // Add the new blogData to the list
      bookmarkedBlogs.add(blogData);

      // Convert the updated list to JSON strings
      final List<String> updatedBookmarkedBlogsJson =
          bookmarkedBlogs.map((e) => json.encode(e)).toList();

      // Save the updated list back to SharedPreferences
      await sharedPreferences.setStringList(
          _bookmarkKey, updatedBookmarkedBlogsJson);

      log("local_data+layer: BookMark Added $bookmarkedBlogs");

      return const Right(null); // Successfully bookmarked
    } catch (e) {
      throw Exception('local datasource Bookmark creating error: $e');
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getAllBookmarks() async {
    try {
      final List<String>? bookmarkedBlogsJson =
          sharedPreferences.getStringList(_bookmarkKey);
      final List<Map<String, dynamic>> bookmarkedBlogsMaped =
          bookmarkedBlogsJson
                  ?.map((e) => Map<String, dynamic>.from(json.decode(e)))
                  .toList() ??
              [];

      List<Article> articles = [];

      try {
        for (var blog in bookmarkedBlogsMaped) {
          articles.add(Article.fromJson(blog));
        }
      } catch (e) {
        log("Error fetching tags: $e");
        throw Exception('An error occurred: $e');
      }
      //Article article_bookmark = Article.fromJson(bookmarkedBlogsMaped);

      return Right(articles);
    } catch (e) {
      throw Exception('Bookmark getting from local data source error: $e');
    }
  }

  @override
  Future<Either<Failure, void>> createArticle(Article article) {
    // TODO: implement createArticle
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deleteArticle(String articleId) {
    // TODO: implement deleteArticle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Article>> getAllArticle(String tags) {
    // TODO: implement getAllArticle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Article>>> getAllArticles() {
    // TODO: implement getAllArticles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Article>> getSingleArticle(String articleId) {
    // TODO: implement getSingleArticle
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getTags() {
    // TODO: implement getTags
    throw UnimplementedError();
  }

  @override
  Future<List<Article>> searchArticle(String tag, String key) {
    // TODO: implement searchArticle
    throw UnimplementedError();
  }
}
