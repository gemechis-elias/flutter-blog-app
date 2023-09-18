import '../../../domain/entities/article.dart';
import '../bloc_state.dart';

class DeleteBlogState extends BlogState {
  DeleteBlogState();

  @override
  List<Object> get props => [];
}

class DeletedBlogState extends BlogState {
  final Article article;

  DeletedBlogState(this.article);

  @override
  List<Object> get props => [];
}
