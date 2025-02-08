import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';
import 'package:flutter_post_management_crud/domain/repositories/post_repository.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  static const int postLimit = 20;
  int currentStart = 0;

  PostBloc({required this.postRepository}) : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<CreatePostEvent>(_onCreatePost);
    on<UpdatePostEvent>(_onUpdatePost);
    on<DeletePostEvent>(_onDeletePost);
  }

  Future<void> _onFetchPosts(
      FetchPosts event, Emitter<PostState> emit) async {
    try {
      // For refresh or first load
      List<Post> posts = [];
      if (event.isRefresh || state is PostInitial) {
        emit(PostLoading());
        currentStart = 0;
      } else if (state is PostLoaded) {
        posts = List<Post>.from((state as PostLoaded).posts);
      }
      final newPosts = await postRepository.fetchPosts(
          start: currentStart, limit: postLimit);
      currentStart += postLimit;
      final hasReachedMax = newPosts.length < postLimit;
      posts.addAll(newPosts);
      emit(PostLoaded(posts: posts, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onCreatePost(
      CreatePostEvent event, Emitter<PostState> emit) async {
    try {
      final newPost = await postRepository.createPost(
          title: event.title, body: event.body);
      if (state is PostLoaded) {
        final currentPosts = List<Post>.from((state as PostLoaded).posts);
        currentPosts.insert(0, newPost);
        emit(PostLoaded(
            posts: currentPosts,
            hasReachedMax: (state as PostLoaded).hasReachedMax));
      } else {
        add(const FetchPosts(isRefresh: true));
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePost(
      UpdatePostEvent event, Emitter<PostState> emit) async {
    try {
      final updatedPost = await postRepository.updatePost(
          id: event.id, title: event.title, body: event.body);
      if (state is PostLoaded) {
        final currentPosts = (state as PostLoaded).posts.map((post) {
          return post.id == event.id ? updatedPost : post;
        }).toList();
        emit(PostLoaded(
            posts: currentPosts,
            hasReachedMax: (state as PostLoaded).hasReachedMax));
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void> _onDeletePost(
      DeletePostEvent event, Emitter<PostState> emit) async {
    try {
      await postRepository.deletePost(id: event.id);
      if (state is PostLoaded) {
        final currentPosts = (state as PostLoaded)
            .posts
            .where((post) => post.id != event.id)
            .toList();
        emit(PostLoaded(
            posts: currentPosts,
            hasReachedMax: (state as PostLoaded).hasReachedMax));
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
