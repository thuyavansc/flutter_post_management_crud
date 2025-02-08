import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/my_app_style.dart';
import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'presentation/blocs/post_bloc.dart';
import 'presentation/routes/app_router.dart';

void main() {
  // Initialize the remote data source and repository.
  final postRemoteDataSource = PostRemoteDataSource();
  final postRepository =
  PostRepositoryImpl(remoteDataSource: postRemoteDataSource);

  runApp(MyApp(postRepository: postRepository));
}

class MyApp extends StatelessWidget {
  final PostRepositoryImpl postRepository;

  const MyApp({Key? key, required this.postRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: postRepository,
      child: BlocProvider(
        create: (_) => PostBloc(postRepository: postRepository),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: ThemeData(
            primaryColor: MyAppStyle.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: MyAppStyle.primaryColor,
              elevation: 0,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: MyAppStyle.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

