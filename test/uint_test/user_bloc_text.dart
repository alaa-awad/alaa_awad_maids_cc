import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_cc_alaa_awad_test/controller/user_bloc/user_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/user_bloc/user_state.dart';
import 'package:maids_cc_alaa_awad_test/core/error/exceptions.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late UserBloc userBloc;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    userBloc = UserBloc(mockDio);
  });

  tearDown(() {
    userBloc.close();
  });

  group('changePasswordVisibility', () {
    blocTest<UserBloc, UserState>(
      'emits AddUserChangePasswordVisibilityState when called',
      build: () => userBloc,
      act: (bloc) => bloc.changePasswordVisibility(),
      expect: () => [isA<AddUserChangePasswordVisibilityState>()],
    );
  });

  group('logInCubit', () {
    final mockResponse = Response(data: {}, statusCode: 200, requestOptions: RequestOptions());

    blocTest<UserBloc, UserState>(
      'emits LogInLoadingState, LogInSuccessState on successful login',
      build: () {
        when(() => mockDio.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => mockResponse);
        return userBloc;
      },
      act: (bloc) => bloc.logInCubit(email: 'test@test.com', password: 'password'),
      expect: () => [isA<LogInLoadingState>(), isA<LogInSuccessState>()],
    );

    blocTest<UserBloc, UserState>(
      'emits LogInLoadingState, LogInErrorState on server error',
      build: () {
        when(() => mockDio.post(any(), data: any(named: 'data')))
            .thenThrow(ServerException());
        return userBloc;
      },
      act: (bloc) => bloc.logInCubit(email: 'test@test.com', password: 'password'),
      expect: () => [isA<LogInLoadingState>(), isA<LogInErrorState>()],
    );

  });
}