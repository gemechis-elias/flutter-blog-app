import 'dart:io';

import 'package:blog_app/features/blog/presentation/blocs/bloc_event.dart';

class DeleteBlogEvent extends BlogEvent {
  final String id;

  const DeleteBlogEvent({
    required this.id,
  });
  @override
  List<Object> get props => [];
}
