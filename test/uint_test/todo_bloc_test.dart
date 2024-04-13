import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_state.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late TodoBloc todoBloc;
  late MockDio mockDio;

  final requestOptions = RequestOptions(
    path: '/info',
    method: 'GET', // or any other HTTP method required
    // You may need to set other properties based on your implementation
  );

  setUp(() {
    mockDio = MockDio();
    todoBloc = TodoBloc(mockDio);
  });
  tearDown(() {
    todoBloc.close();
  });

  group('getData', () {
    final mockResponse = Response(data: {
      "todos": [
        {
          "id": 1,
          "todo": "Do something nice for someone I care about",
          "completed": true,
          "userId": 26
        },
        {
          "id": 2,
          "todo": "Do something nice for someone I care about",
          "completed": true,
          "userId": 26
        },
      ],
      "total": 150,
      "skip": 0,
      "limit": 30
    }, statusCode: 200, requestOptions: RequestOptions());

    blocTest<TodoBloc, TodoState>(
      'emits LoadingState, GetDataSuccessState on successful fetch',
      build: () {
        when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);
        return todoBloc;
      },
      act: (bloc) => bloc.getData(),
      expect: () => [isA<LoadingState>(), isA<GetDataSuccessState>()],
      // verify: (blocUnderTest) {
      //   expect(blocUnderTest.todosList.length, 1);
      // },
    );

    blocTest<TodoBloc, TodoState>(
      'emits LoadingState, GetDataErrorState on error',
      build: () {
        when(() => mockDio.get(any())).thenThrow(Exception());
        return TodoBloc(mockDio);
      },
      act: (bloc) => bloc.getData(),
      expect: () => [isA<LoadingState>(), isA<GetDataErrorState>()],
    );
  });
}
