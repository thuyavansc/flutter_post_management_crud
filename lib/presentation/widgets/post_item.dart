import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_bloc.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_event.dart';
import 'package:go_router/go_router.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(post.body),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Pass the existing post as extra for editing.
              // context.go('/post', extra: post);
              context.push('/post', extra: post);
            } else if (value == 'delete') {
              BlocProvider.of<PostBloc>(context)
                  .add(DeletePostEvent(id: post.id));
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ];
          },
        ),
      ),
    );
  }
}
