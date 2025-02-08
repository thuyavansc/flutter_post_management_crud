import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_post_management_crud/presentation/pages/post_list_page.dart';
import 'package:flutter_post_management_crud/presentation/pages/post_form_page.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'postList',
        builder: (context, state) => const PostListPage(),
      ),
      GoRoute(
        path: '/post',
        name: 'postForm',
        builder: (context, state) {
          // If editing, a Post entity is passed via state.extra.
          final post = state.extra as Post?;
          return PostFormPage(post: post);
        },
      ),
    ],
  );
}
