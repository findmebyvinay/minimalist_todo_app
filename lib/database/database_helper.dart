
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/todo_model.dart';
class DatabaseHelper {
  static const _databaseName = 'todo.db';
  static const _databaseVersion = 2;

 Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    print('Database path: $path');
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        print('Creating todos table');
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            isCompleted INTEGER,
            todoType TEXT,
            customType TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('Upgrading database from version $oldVersion to $newVersion');
        if (oldVersion < 2) {
          // Drop existing table if it exists (to ensure clean schema)
          await db.execute('DROP TABLE IF EXISTS todos');
          // Recreate table
          await db.execute('''
            CREATE TABLE todos (
              id TEXT PRIMARY KEY,
              name TEXT,
              description TEXT,
              isCompleted INTEGER,
              todoType TEXT,
              customType TEXT,
              createdAt TEXT,
              updatedAt TEXT
            )
          ''');
        }
      },
      onOpen: (db) async {
        var tableExists = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='todos'",
        );
        print('Table exists: $tableExists');
      },
    );
  }Future<int> insertTodo(TodoModel todo) async {
    final db = await initDatabase();
    print('Inserting todo: ${todo.toMap()}');
    try {
      return await db.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting todo: $e');
      rethrow; // Propagate error to TodoBloc
    }
  }

  Future<List<TodoModel>> fetchTodos() async {
    final db = await initDatabase();
    try {
      final maps = await db.query('todos');
      print('Fetched todos: $maps');
      return maps.map((map) => TodoModel.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching todos: $e');
      rethrow;
    }
  }

  Future<int> updateTodo(TodoModel todo) async {
    final db = await initDatabase();
    print('Updating todo: ${todo.toMap()}');
    try {
      return await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } catch (e) {
      print('Error updating todo: $e');
      rethrow;
    }
  }

  Future<int> deleteTodo(String todoId) async {
    final db = await initDatabase();
    print('Deleting todo with id: $todoId');
    try {
      return await db.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [todoId],
      );
    } catch (e) {
      print('Error deleting todo: $e');
      rethrow;
    }
  }
 }

// class DatabaseHelper {
//  static const String _databaseName= 'todo.db';
//  static const int version=1;
//    static const String tableTodos = 'todos';

//   static final  DatabaseHelper _instance= DatabaseHelper._internal();
//   factory DatabaseHelper()=>_instance;
//   DatabaseHelper._internal();

//   Database? _database;  
//   Future<Database> get database async{
//     if(_database !=null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database>_initDatabase()async{
//     final String path =join(await getDatabasesPath(),_databaseName);
//     return await openDatabase(
//       path,
//       version: version,
//       onCreate: _onCreate);

//   }

//   Future<void> _onCreate(Database db,int version)async{
//     await db.execute(
//       '''
//       CREATE TABLE todo(
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       name TEXT NOT NULL,
//       description TEXT NOT NULL,
//       isCompeleted INTEGER NOT NULL,
//       todoType TEXT,
//       createdAt TEXT,
//       updatedAt TEXT
//       )
//       '''
//     );
//   }

//    // CRUD Operations
//   Future<int> insertTodo(TodoModel todo) async {
//     final db = await database;
//     print(db);
//     return await db.insert(
//       tableTodos,
//       todo.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
    
//   }

//   Future<List<TodoModel>> getTodos() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(tableTodos);
//     return List.generate(maps.length, (i) => TodoModel.fromMap(maps[i]));
//   }

//   Future<int> updateTodo(TodoModel todo) async {
//     final db = await database;
//     return await db.update(
//       tableTodos,
//       todo.toMap(),
//       where: 'id = ?',
//       whereArgs: [todo.id],
//     );
//   }

//   Future<int> deleteTodo(int id) async {
//     final db = await database;
//     return await db.delete(
//       tableTodos,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   Future<void> closeDatabase() async {
//     if (_database != null) {
//       await _database!.close();
//       _database = null;
//     }
//   }
// }