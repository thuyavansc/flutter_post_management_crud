import 'package:equatable/equatable.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostEvent {
  final bool isRefresh;
  const FetchPosts({this.isRefresh = false});
}

class CreatePostEvent extends PostEvent {
  final String title;
  final String body;
  const CreatePostEvent({required this.title, required this.body});
}

class UpdatePostEvent extends PostEvent {
  final int id;
  final String title;
  final String body;
  const UpdatePostEvent({
    required this.id,
    required this.title,
    required this.body,
  });
}

class DeletePostEvent extends PostEvent {
  final int id;
  const DeletePostEvent({required this.id});
}
