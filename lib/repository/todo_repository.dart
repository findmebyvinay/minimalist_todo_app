import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:todoo_app/database/database_helper.dart';
import 'package:todoo_app/model/todo_model.dart';

class TodoRepository {
  final DatabaseHelper databaseService;
  TodoRepository({required this.databaseService});

  Future<int> addTodo(TodoModel todo)async{
    return await databaseService.insertTodo(todo);
    
  }

  Future<List<TodoModel>> fetchTodo()async{
    return await databaseService.fetchTodos();
  }

  Future<int> updateTodo(TodoModel todo)async{
    return await databaseService.updateTodo(todo);
  }

  Future<int> deleteTodo(String id)async{
    return await databaseService.deleteTodo(id);
  }
}