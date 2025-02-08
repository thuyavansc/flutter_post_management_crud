import 'package:flutter_post_management_crud/domain/entities/post.dart';
import 'package:flutter_post_management_crud/domain/repositories/post_repository.dart';
import 'package:flutter_post_management_crud/data/datasources/post_remote_data_source.dart';
import 'package:flutter_post_management_crud/data/models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Post>> fetchPosts({required int start, required int limit}) async {
    final postsJson = await remoteDataSource.fetchPosts(start: start, limit: limit);
    return postsJson.map<Post>((json) => PostModel.fromJson(json)).toList();
  }

  @override
  Future<Post> createPost({required String title, required String body}) async {
    final json = await remoteDataSource.createPost(title: title, body: body);
    return PostModel.fromJson(json);
  }

  @override
  Future<Post> updatePost({required int id, required String title, required String body}) async {
    final json = await remoteDataSource.updatePost(id: id, title: title, body: body);
    return PostModel.fromJson(json);
  }

  @override
  Future<void> deletePost({required int id}) async {
    await remoteDataSource.deletePost(id: id);
  }
}
