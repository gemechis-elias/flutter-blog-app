import 'package:blog_app/features/blog/presentation/blocs/bloc_state.dart';

import '../../../../domain/entities/article.dart';

class BookmarkLoading extends BlogState {}

class BookmarkError extends BlogState {
  final String errorMessage;

  BookmarkError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LoadedBookmarksState extends BlogState {
  final List<Article> article;

  const LoadedBookmarksState(this.article);

  @override
  List<Object> get props => [article];
}
