import 'package:equatable/equatable.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostLoaded({
    required this.posts,
    this.hasReachedMax = false,
  });

  PostLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

class PostError extends PostState {
  final String message;
  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}
