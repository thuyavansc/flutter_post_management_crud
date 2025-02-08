import 'package:flutter_post_management_crud/domain/entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> fetchPosts({required int start, required int limit});
  Future<Post> createPost({required String title, required String body});
  Future<Post> updatePost({required int id, required String title, required String body});
  Future<void> deletePost({required int id});
}
