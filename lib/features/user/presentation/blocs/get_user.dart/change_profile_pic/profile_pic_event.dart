import 'package:blog_app/features/user/presentation/blocs/bloc_event.dart';
import 'dart:io';

class ChangeProfileEvent extends UserEvent {
  final File image;
  final int id;

  const ChangeProfileEvent({
    required this.image,
    required this.id,
  });

  @override
  List<Object> get props => [];
}
