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
  final String? errorMessage;

  const PostLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  PostLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, errorMessage];
}

class PostError extends PostState {
  final String message;
  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}
