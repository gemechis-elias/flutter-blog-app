import '../../bloc_state.dart';

class AddingBookmarkState extends BlogState {
  const AddingBookmarkState();

  @override
  List<Object> get props => [];
}

class AddedBookmarkState extends BlogState {
  const AddedBookmarkState();

  @override
  List<Object> get props => [];
}

class AddBookmarkError extends BlogState {
  final String errorMessage;

  const AddBookmarkError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}