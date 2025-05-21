import 'package:equatable/equatable.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:todoo_app/model/todo_model.dart';

abstract class TodoState extends Equatable{
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState{

}

class TodoLoading extends TodoState{

}

class TodoLoaded extends TodoState{
  final List<TodoModel> todo;
  TodoLoaded(this.todo);

  @override
  List<Object> get props=> [todo];
}
class TodoError extends TodoState{
  final String message;
  TodoError(this.message);

  @override
  List<Object> get props=> [message];
}

class TodoAdded extends TodoState {
  final int todoId;

   TodoAdded(this.todoId);

  @override
  List<Object> get props => [todoId];
}

class TodoUpdated extends TodoState {
  final int todoId;
 
  TodoUpdated(this.todoId);

  @override
  List<Object> get props => [todoId];
}

class TodoDeleted extends TodoState {
  final int todoId;

   TodoDeleted(this.todoId);

  @override
  List<Object> get props => [todoId];
}
class TodoToggled extends TodoState{
  final TodoModel todo;
  TodoToggled(this.todo);
  
  @override
  List<Object> get props=>[todo];
}