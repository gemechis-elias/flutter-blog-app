import 'package:blog_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/article.dart';
import '../repositories/article_repository.dart';

class GetBookmarkUseCase {
  final ArticleRepository repository;

  GetBookmarkUseCase(this.repository);

  Future<Either<Failure, List<Article>>> call() async {
    return await repository.getAllBookmarks();
  }
}
