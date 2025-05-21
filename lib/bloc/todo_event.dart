import 'package:equatable/equatable.dart';
import 'package:todoo_app/model/todo_model.dart';

abstract class TodoEvent extends Equatable{
  @override
  List<Object> get props=>[];

}

class  FetchTodo extends TodoEvent{

}

class AddTodoEvent extends TodoEvent{
  final TodoModel todo;
  AddTodoEvent(this.todo);

  @override
  List<Object> get props=>[todo];

}

class UpdateTodoEvent extends TodoEvent{
  final TodoModel todo;
  UpdateTodoEvent(this.todo);
  @override
  List<Object> get props=>[todo];
}

class DeleteTodoEvent extends TodoEvent{
  final String todoId;
  DeleteTodoEvent(this.todoId);

  @override
  List<Object> get props =>[todoId];
}

class ToggleTodoCompletionEvent extends TodoEvent {
  final TodoModel todo;

   ToggleTodoCompletionEvent(this.todo);

  @override
  List<Object> get props => [todo];
}