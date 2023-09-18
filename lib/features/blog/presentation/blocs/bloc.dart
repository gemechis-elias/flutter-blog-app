import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/domain/entities/article.dart';
import 'package:blog_app/features/blog/domain/usecases/create_article.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_article.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_articles.dart';
import 'package:blog_app/features/blog/domain/usecases/get_single_article.dart';
import 'package:blog_app/features/blog/domain/usecases/get_tags.dart';
import 'package:blog_app/features/blog/presentation/blocs/create_blog/create_blod_state.dart';
import 'package:blog_app/features/blog/presentation/blocs/create_blog/create_blog_event.dart';
import 'package:blog_app/features/blog/presentation/blocs/delete_blog/delete_blog_event.dart';
import 'package:blog_app/features/blog/presentation/blocs/delete_blog/delete_blog_state.dart';
import 'package:blog_app/features/blog/presentation/blocs/get_tags/get_tag_event.dart';
import 'package:blog_app/features/blog/presentation/blocs/get_tags/get_tag_state.dart';
import 'package:dartz/dartz.dart';

import '../../domain/usecases/add_bookmark.dart';
import '../../domain/usecases/get_all_bookmarks.dart';
import 'add_bookmark/bloc/add_bookmark_event.dart';
import 'add_bookmark/bloc/add_bookmark_state.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';
import 'get_bookmarks/bloc/get_bookmark_event.dart';
import 'get_bookmarks/bloc/get_bookmark_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetArticleUseCase getAllArticle;
  final GetSingleArticleUseCase getSingleArticle;
  final GetTagsUseCase getTags;
  final CreateArticleUseCase createArticle;
  final DeleteArticleUseCase deleteArticle;
  final AddBookmarkUseCase addBookmark;
  final GetBookmarkUseCase getBookmark;

  BlogBloc(
      {required this.getAllArticle,
      required this.getSingleArticle,
      required this.getTags,
      required this.createArticle,
      required this.deleteArticle,
      required this.addBookmark,
      required this.getBookmark})
      : super(BlogInitial()) {
    on<GetAllArticlesEvent>((event, emit) async {
      emit(BlogLoading());

      try {
        final Either<Failure, List<Article>> result = await getAllArticle();
        emit(result.fold(
          (failure) => BlogError(_mapFailureToMessage(failure)),
          (articles) => LoadedGetBlogState(articles),
        ));
      } catch (e) {
        emit(BlogError(_mapFailureToMessage(
            const ServerFailure('Error fetching articles'))));
      }
    });
    on<GetBookmarksEvent>((event, emit) async {
      emit(BookmarkLoading());

      try {
        log("bookmark bloc started");
        final Either<Failure, List<Article>> result = await getBookmark();
        emit(result.fold(
          (failure) => BookmarkError(_mapFailureToMessage(failure)),
          (articles) => LoadedBookmarksState(articles),
        ));
      } catch (e) {
        emit(BookmarkError(_mapFailureToMessage(
            const ServerFailure('Error fetching bookmark'))));
      }
    });

    on<AddBookmarkEvent>((event, emit) async {
      try {
        emit(AddingBookmarkState());
        print('Adding bookmark - STARTED');
        final Either<Failure, Article> result =
            await addBookmark(AddBookmarkParams(
          title: event.title,
          content: event.content,
          subTitle: event.subTitle,
          image: event.image,
          tagList: event.tags,
        ));
        print("Finished processing - in the bookmark bloc");
        emit(result.fold(
          (failure) => BlogError(_mapFailureToMessage(failure)),
          (article) => CreatedBlogState(),
        ));
      } catch (e) {
        emit(AddBookmarkError('Error creating bookmark '));
      }
    });

    on<GetTagsEvent>((event, emit) async {
      emit(TagLoading());

      try {
        final Either<Failure, List<String>> result = await getTags();
        emit(result.fold(
          (failure) => BlogError(_mapFailureToMessage(failure)),
          (tags) => LoadedTagsState(tags),
        ));
      } catch (e) {
        emit(BlogError(
            _mapFailureToMessage(const ServerFailure('Error fetching tags'))));
      }
    });

    on<CreateBlogEvent>((event, emit) async {
      try {
        emit(CreatingBlogState());
        print('Creating blog - STARTED');

        final Either<Failure, Article> result =
            await createArticle(CreateArticleParams(
          title: event.title,
          content: event.content,
          subTitle: event.subTitle,
          image: event.image,
          tagList: event.tags,
        ));
        print("Finished processing - in the bloc");
        // emit UserSignedInState
        emit(result.fold(
          (failure) => BlogError(_mapFailureToMessage(failure)),
          (article) => CreatedBlogState(),
        ));
      } catch (e) {
        emit(BlogError('Error creating blog'));
      }

      // print();
    });

    on<DeleteBlogEvent>((event, emit) async {
      try {
        emit(DeleteBlogState());
        log('Deleting blog - STARTED');

        final Either<Failure, Article> result = await deleteArticle(event.id);
        log("Finished processing - in the bloc");
        // emit UserSignedInState
        emit(result.fold(
          (failure) => BlogError(_mapFailureToMessage(failure)),
          (article) => DeletedBlogState(article),
        ));
      } catch (e) {
        emit(BlogError('Error deleteing blog'));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred: $failure';
  }
}
