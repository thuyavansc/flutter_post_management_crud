import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_bloc.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_event.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({Key? key, required this.post}) : super(key: key);

  Future<void> _handleEdit(BuildContext context) async {
    // Check connectivity before editing.
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection. Cannot edit post.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    // Navigate to the edit post page.
    context.push('/post', extra: post);
  }

  Future<void> _handleDelete(BuildContext context) async {
    // Check connectivity before deleting.
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection. Cannot delete post.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    BlocProvider.of<PostBloc>(context).add(DeletePostEvent(id: post.id));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.body),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              await _handleEdit(context);
            } else if (value == 'delete') {
              await _handleDelete(context);
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
