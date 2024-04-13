import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:maids_cc_alaa_awad_test/controller/user_bloc/user_event.dart';
import 'package:maids_cc_alaa_awad_test/controller/user_bloc/user_state.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Dio dio;

  static UserBloc get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  final NetworkInfo networkInfo = NetworkInfoImpl(InternetConnectionChecker());

  UserBloc(
      this.dio,
      ) : super(UserInitial());

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(AddUserChangePasswordVisibilityState());
  }

  void logInCubit({
    required String email,
    required String password,
  }) async {
    emit(LogInLoadingState());
    if (await networkInfo.isConnected) {
      try {
        // Make a POST request to the login URL with email and password
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': email,
            'password': password,
          },
        );
        print("response.statusCode ${response.statusCode}");
        // Check if the response is successful
        if (response.statusCode == 200) {
          emit(LogInSuccessState());
        }
        else {
          // Login failed, handle the error
          emit(const LogInErrorState("Error Server"));
        }
      } on ServerException {
        emit(const LogInErrorState("Error Server"));
      }
    }
    else {
      emit(const LogInErrorState("Error There is no network"));
    }
  }
  
}


