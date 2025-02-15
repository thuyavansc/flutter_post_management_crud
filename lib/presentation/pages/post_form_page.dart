import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_management_crud/domain/entities/post.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_bloc.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_event.dart';
import 'package:flutter_post_management_crud/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;
  const PostFormPage({Key? key, this.post}) : super(key: key);

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Check connectivity before attempting to submit.
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection. Cannot submit post.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final body = _bodyController.text;
      if (widget.post == null) {
        BlocProvider.of<PostBloc>(context)
            .add(CreatePostEvent(title: title, body: body));
      } else {
        BlocProvider.of<PostBloc>(context).add(UpdatePostEvent(
            id: widget.post!.id, title: title, body: body));
      }
      // Close the form page after a successful submission.
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: Validators.validateNotEmpty,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                validator: Validators.validateNotEmpty,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
