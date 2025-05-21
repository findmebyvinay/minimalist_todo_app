import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:todoo_app/model/todo_model.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';
import 'package:get/get.dart';
import '../constant/app_theme.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todo;

   TodoCard({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isChecked= false;

    //  print(isChecked);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox for completion status
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value:isChecked,
                  //  widget.todo.isCompleted,
                  activeColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? value) {
                       context.read<TodoBloc>().add(ToggleTodoCompletionEvent(widget.todo));
                      
                    // setState(() {
                    // isChecked= value!;
                    // print(isChecked);
                    // });
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Todo content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.getTypeColor(widget.todo.todoType.index).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getTypeText(widget.todo.todoType, widget.todo.customType),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.getTypeColor(widget.todo.todoType.index),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Action buttons
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: Colors.blueGrey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          Get.toNamed('/edit-todo', arguments: widget.todo);
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.redAccent,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.todo.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      color: widget.todo.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.todo.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.todo.isCompleted ? Colors.grey : Colors.black54,
                      decoration: widget.todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeText(TodoType type, String? customType) {
    switch (type) {
      case TodoType.education:
        return 'Education';
      case TodoType.entertainment:
        return 'Entertainment';
      case TodoType.health:
        return 'Health';
      case TodoType.other:
        return customType ?? 'Other';
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this todo?'),
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (widget.todo.id != null) {
                  context.read<TodoBloc>().add(DeleteTodoEvent(widget.todo.id.toString()));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}