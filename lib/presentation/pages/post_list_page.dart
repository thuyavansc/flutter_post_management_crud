import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_bloc.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_event.dart';
import 'package:flutter_post_management_crud/presentation/blocs/post_state.dart';
import 'package:flutter_post_management_crud/presentation/widgets/post_item.dart';
import 'package:go_router/go_router.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(const FetchPosts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      BlocProvider.of<PostBloc>(context).add(const FetchPosts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Modified _refresh method to check connectivity before refreshing.
  Future<void> _refresh() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
        msg: "No internet connection. Please check your connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      // Do not trigger a refresh; keep already loaded posts.
      return;
    }
    // If connected, dispatch a refresh event.
    BlocProvider.of<PostBloc>(context).add(const FetchPosts(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/post');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading && state is! PostLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts available'));
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.posts.length) {
                    final post = state.posts[index];
                    return PostItem(post: post);
                  } else {
                    // This extra widget displays loading, error, or "End of Posts"
                    if (state.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'Error: ${state.errorMessage}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<PostBloc>(context)
                                      .add(const FetchPosts());
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state.hasReachedMax) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text('End of Posts')),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  }
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
