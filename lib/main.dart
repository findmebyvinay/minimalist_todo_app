import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todoo_app/bloc/todo_bloc.dart';
import 'package:todoo_app/database/database_helper.dart';
import 'package:todoo_app/model/todo_model.dart';
import 'package:todoo_app/repository/todo_repository.dart';
import 'package:todoo_app/view/add_todo_page.dart';
import 'package:todoo_app/view/on_board_screen.dart';
import 'package:todoo_app/view/todo_card.dart';
import 'package:todoo_app/view/todo_list_page.dart';

import 'constant/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Set preferred orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Catch unhandled errors
  FlutterError.onError = (details) {
    print('Unhandled Flutter error: ${details.exceptionAsString()}');
    print(details.stack);
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final DatabaseHelper localDataSource;
  late final TodoRepository todoRepository;
  late final TodoBloc todoBloc;
  @override
  void initState() {
    localDataSource = DatabaseHelper();
    todoRepository = TodoRepository(databaseService: localDataSource);
    todoBloc = TodoBloc(todoRepo: todoRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepository(databaseService: localDataSource),
      child: BlocProvider(
        create: (context) => TodoBloc(
            todoRepo: context.read<TodoRepository>()),
        child: GetMaterialApp(
          title: 'Todo App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: '/onBoard',
          getPages: [
            GetPage(name: '/onBoard', page: () => const OnBoardScreen()),
            GetPage(name: '/todoPage', page: () => const TodoListPage()),
            GetPage(name: '/add-todo', page: () => const AddTodoPage()),
            GetPage(
              name: '/edit-todo',
              page: () {
                final TodoModel todo = Get.arguments;
                return AddTodoPage(todoToEdit: todo);
              },
            ),
          ],
        ),
      ),
    );
  }
}
