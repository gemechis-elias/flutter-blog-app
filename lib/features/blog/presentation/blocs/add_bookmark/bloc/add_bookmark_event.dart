import 'package:blog_app/features/blog/presentation/blocs/bloc_event.dart';
import 'dart:io';

class AddBookmarkEvent extends BlogEvent {
  final String title;
  final String subTitle;
  final String tags;
  final String content;
  final File image;

  const AddBookmarkEvent({
    required this.title,
    required this.subTitle,
    required this.tags,
    required this.content,
    required this.image,
  });

  @override
  List<Object> get props => [];
}
