import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_cc_alaa_awad_test/view/log_in_page/login_screen.dart';
import 'controller/todo_bloc/todo_bloc.dart';
import 'controller/user_bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(Dio()), // assuming dio is not needed here
        ),
        BlocProvider<TodoBloc>(
          create: (BuildContext context) =>
              TodoBloc(Dio())..getData(), // assuming dio is not needed here
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
