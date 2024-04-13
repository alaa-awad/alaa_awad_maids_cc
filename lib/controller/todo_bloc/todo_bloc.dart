import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_event.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_state.dart';
import '../../model/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final Dio dio;

  TodoBloc(
    this.dio,
  ) : super(InitState());

  static TodoBloc get(context) => BlocProvider.of(context);
  List<Todo> todosList = [];

  void toggleTodoChecked(int index, bool value) {
    if (index >= 0 && index < todosList.length) {
      todosList[index].completed = value;
    }
    updateData(
        todosList[index].id,
        {
          "todo": todosList[index].todo,
          "completed": value,
          "userId": 5,
        },
        index);
    emit(ToggleState());
  }

  //code get data
  Future<void> getData() async {
    emit(LoadingState());
    try {
      Response response = await dio.get("https://dummyjson.com/todos");
      if (response.statusCode == 200) {
        List<Todo> todos = [];
        //print("response.data ${response.data["todos"]}");
        for (var i in response.data["todos"]) {
          todos.add(Todo.fromJson(i));
        }
        todosList = todos;
        emit(GetDataSuccessState(todos));
        // yield GetDataSuccessState(emails);
      }
      else {
        emit(GetDataErrorState());
        // yield GetDataErrorState();
      }
    } catch (e) {
      print("error Get Data is $e");
      emit(GetDataErrorState());
      // yield GetDataErrorState();
    }
  }

  //code update data
  Future<void> updateData(int id, Map<String, dynamic> data, int index) async {
    emit(LoadingState());
    Response response = await dio.put(
      "https://dummyjson.com/todos/$id",
      data: data,
    );
    print("response.statusCode update is ${response.statusCode}");
    print("response update is $response");
    if (response.statusCode == 200) {
      todosList[index].todo = data["todo"];
      todosList[index].completed = data["completed"];
      emit(UpdateDataSuccessState());
    } else {
      emit(UpdateDataErrorState());
    }
  }

  // code post data to dataBase
  Future<void> postData(Map<String, dynamic> data) async {
    emit(LoadingState());
    Response response = await dio.post(
      "https://dummyjson.com/todos/add",
      data: data,
    );
    if (response.statusCode == 200) {
      todosList.add(Todo.fromJson(response.data));
      emit(PostDataSuccessState());
    } else {
      emit(PostDataErrorState());
    }
  }

  // code delete data in dataBase
  Future<void> deleteData(int id,int index) async {
    emit(LoadingState());
    Response response = await dio.delete(
      "https://dummyjson.com/todos/$id",
    );
    print("response.statusCode delete = ${response.statusCode}");
    print("response delete is $response");
    if (response.statusCode == 200) {
      todosList.removeAt(index);
      emit(DeleteDataSuccessState());
    } else {
      emit(DeleteDataErrorState());
    }
  }
}
