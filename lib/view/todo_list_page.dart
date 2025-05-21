import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:todoo_app/database/database_helper.dart';
import 'package:todoo_app/repository/todo_repository.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';
import '../../bloc/todo_state.dart';
import '../model/todo_model.dart';
import 'todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  
  
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(FetchTodo());
    print(FetchTodo());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        elevation: 0,
      ),
       body:BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          print(state); // For debugging
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todo.isEmpty) {
              return _buildEmptyState();
            }
            return _buildTodoList(state);
          } else if (state is TodoError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is TodoInitial) {
            return const Center(child: Text('Initializing...'));
          }
          return const Center(child: Text('Start by adding a task!'));
        },
      ),
        // BlocBuilder<TodoBloc, TodoState>(
      //   builder: (context, state) {
      //     if (state is TodoLoading) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (state is TodoLoaded) {
      //       if (state.todo.isEmpty) {
      //         return _buildEmptyState();
      //       }
      //       return _buildTodoList(state);
      //     } else if (state is TodoError) {
      //       return Center(
      //         child: Text(
      //           'Error: ${state.message}',
      //           style: const TextStyle(color: Colors.red),
      //         ),
      //       );
      //     }
      //     return const Center(
      //       child: Text('Start by adding a task!'),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-todo'),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new task by tapping the + button',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(TodoLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: state.todo.length,
      itemBuilder: (context, index) {
        final todo = state.todo[index];
        return TodoCard(todo: todo);
      },
    );
  }
}
