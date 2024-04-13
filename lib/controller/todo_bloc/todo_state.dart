
import '../../model/todo_model.dart';

abstract class TodoState {}

class InitState extends TodoState {}

class LoadingState extends TodoState {}

class ToggleState extends TodoState {}

class GetDataSuccessState extends TodoState {
  List<Todo> todos;
  GetDataSuccessState(this.todos);
}

class GetDataErrorState extends TodoState {}

class PostDataSuccessState extends TodoState {}

class PostDataErrorState extends TodoState {}

class UpdateDataSuccessState extends TodoState {}

class UpdateDataErrorState extends TodoState {}

class DeleteDataSuccessState extends TodoState {}

class DeleteDataErrorState extends TodoState {}
