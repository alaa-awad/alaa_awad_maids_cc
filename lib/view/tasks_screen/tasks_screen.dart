import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_state.dart';
import 'package:maids_cc_alaa_awad_test/view/tasks_screen/widgets/add_update_dialog.dart';

import '../../model/todo_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int currentPage = 1;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    var todoBloc = BlocProvider.of<TodoBloc>(context);
    int totalItems = todoBloc.todosList.length;

    List<Todo> displayedItems = todoBloc.todosList
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();
   int startIndex = (currentPage - 1) * itemsPerPage + 1;
   int  endIndex = (startIndex + itemsPerPage - 1).clamp(1, totalItems);

    return Scaffold(
      // ... (other parts of your Scaffold remain unchanged)
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (BuildContext context, TodoState state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: displayedItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value: displayedItems[index].completed,
                          onChanged: (bool? value) {
                            todoBloc.toggleTodoChecked(
                                todoBloc.todosList
                                    .indexOf(displayedItems[index]),
                                value ?? false);
                          },
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayedItems[index].todo,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddUpdateDialog(
                                        id: displayedItems[index].id,
                                        todoBloc.todosList.firstWhere((item) =>
                                        item.id ==
                                            displayedItems[index].id),
                                        todoBloc.todosList
                                            .indexOf(displayedItems[index]),
                                        todoBloc: todoBloc,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                )),
                            IconButton(
                                onPressed: () {
                                  todoBloc.deleteData(
                                      displayedItems[index].id,
                                      todoBloc.todosList
                                          .indexOf(displayedItems[index]));
                                  displayedItems.removeAt(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Tasks $startIndex-$endIndex from ${todoBloc.todosList.length} items',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentPage > 1)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage--;
                          });
                        },
                        child: const Text('Previous'),
                      ),
                    if (totalItems > currentPage * itemsPerPage)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPage++;
                          });
                        },
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}
