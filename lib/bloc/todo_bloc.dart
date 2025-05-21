import 'package:bloc/bloc.dart';
import 'package:todoo_app/bloc/todo_state.dart';
import 'package:todoo_app/model/todo_model.dart';
import 'package:todoo_app/repository/todo_repository.dart';

import 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent,TodoState> {
  final TodoRepository todoRepo;
  TodoBloc({required this.todoRepo}):super(TodoInitial()){
    on<FetchTodo> (_onFetchTodo);
    on<AddTodoEvent> (_onAddTodo);
    on<DeleteTodoEvent> (_onDeleteTodo);
    on<UpdateTodoEvent> (_onUpdateTodo);
    on<ToggleTodoCompletionEvent> (_onToggleTodoCompletion);
  }

Future<void> _onFetchTodo(FetchTodo event, Emitter<TodoState> emit) async {
    emit(TodoLoading()); // Emit loading state
    try {
      final todos = await todoRepo.fetchTodo();
      print(todos); // For debugging
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError(e.toString())); // Emit error state
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading()); // Emit loading state
    try {
      final todoId = await todoRepo.addTodo(event.todo);
      print(todoId); // For debugging
      emit(TodoAdded(todoId));
      add(FetchTodo()); // Refresh the todo list
    } catch (e) {
      emit(TodoError(e.toString())); // Emit error state
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading()); // Emit loading state
    try {
      final int todoId = await todoRepo.deleteTodo(event.todoId.toString());
      emit(TodoDeleted(todoId));
      add(FetchTodo());
    } catch (e) {
      emit(TodoError(e.toString())); // Emit error state
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading()); // Emit loading state
    try {
      final int todoId = await todoRepo.updateTodo(event.todo);
      emit(TodoUpdated(todoId));
      add(FetchTodo());
    } catch (e) {
      emit(TodoError(e.toString())); // Emit error state
    }
  }
    Future<void> _onToggleTodoCompletion(ToggleTodoCompletionEvent event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final  updatedTodo =  event.todo.copyWith(
        isCompleted: !event.todo.isCompleted,
      );
      print('ToggleTodo is:${updatedTodo.isCompleted}');
      emit( TodoToggled(updatedTodo));
        // emit(TodoUpdated());
      add(FetchTodo());
    } catch (e) {
      emit(TodoError(e.toString()));
    }
  }
  // Future<void> _onFetchTodo(FetchTodo event,Emitter<TodoState> emit)async{
  //   // emit(TodoLoading());
  //   try{
  //       final todos = await todoRepo.fetchTodo();
  //       print(todos);
  //       emit(TodoLoaded(todos));

  //   }
  //   catch(e){
  //     TodoError(e.toString());
  //   }
  // }  

  // Future<void> _onAddTodo(AddTodoEvent event,Emitter<TodoState> emit)async{
  //   //  emit(TodoLoading());
  //    try{

  //     final todoId = await todoRepo.addTodo(event.todo);
  //     print(todoId);
  //     emit(TodoAdded(todoId));
  //     print(TodoAdded(todoId));
  //     add(FetchTodo());      
  //     print(FetchTodo());

  //    }
  //    catch(e){
  //     TodoError(e.toString());
  //    }
  // }

  // Future<void> _onDeleteTodo(DeleteTodoEvent event,Emitter<TodoState> emit)async{
  //   // emit(TodoLoading());
  //   try{
  //      final int todoId = await todoRepo.deleteTodo(event.todoId);
  //      emit(TodoDeleted(todoId));
  //      add(FetchTodo()); 

  //   }
  //   catch(e){
  //     TodoError(e.toString());
  //   }
  // }

  // Future<void> _onUpdateTodo(UpdateTodoEvent event,Emitter<TodoState> emit)async{
  //     // emit(TodoLoading());
  //     try{
  //     final int todoId= await  todoRepo.updateTodo(event.todo);
  //     emit(TodoUpdated(todoId));
  //     add(FetchTodo());
  //     }
  //     catch(e){
  //       TodoError(e.toString());
  //     }
  // }
  

}