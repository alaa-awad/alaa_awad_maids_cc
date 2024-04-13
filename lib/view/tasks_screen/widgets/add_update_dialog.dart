import 'package:flutter/material.dart';

import '../../../controller/todo_bloc/todo_bloc.dart';
import '../../../model/todo_model.dart';

class AddUpdateDialog extends StatefulWidget {
  int id;
  Todo? todo;
  TodoBloc todoBloc;
  int? index;
  AddUpdateDialog(this.todo,this.index, {required this.id,required this.todoBloc, super.key});
  @override
  _AddUpdateDialogState createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  final TextEditingController _titleController = TextEditingController();


  //EmailBloc emailBloc = EmailBloc(Dio());

  @override
  void initState() {
    if (widget.todo != null) {
      _titleController.text = widget.todo!.todo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.todo == null
          ? const Text('Add Todo')
          : const Text('Update Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            String title = _titleController.text;
            if (widget.todo == null) {
              await widget.todoBloc.postData({
                "todo": title,
                "completed": false,
                "userId": 5,
              });
            }
            else {
              print("widget.email!.id, ${widget.todo!.id}");
              await widget.todoBloc.updateData(
                  widget.todo!.id,
                  {
                    "todo": _titleController.text,
                    "completed": widget.todo!.completed,
                    "userId": 5,
              },widget.index!);
            }
            // await emailBloc.getData();

            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
        ElevatedButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
