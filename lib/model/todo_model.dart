import 'package:intl/intl.dart';

enum TodoType{ education, entertainment,health,other}
class TodoModel{
final String? id;
final String name;
final String description;
final bool isCompleted;
final TodoType todoType;
final String? customType;
final DateTime createdAt;
final DateTime? updatedAt;


TodoModel({
  this.id,
  required this.name,
  required this.description,
  required this.isCompleted,
  required this.todoType,
  this.customType,
  required this.createdAt,
  this.updatedAt,
});

factory TodoModel.fromMap(Map<String,dynamic> map){
  return TodoModel(
    id: map['id'],
    name: map['name'],
    description:map['description'],
    todoType: TodoType.values.firstWhere(
        (e) => e.toString() == map['todoType'],
        orElse: () => TodoType.other,
      ),
    isCompleted: map['isCompleted'] ==1 ? true: false,
    customType: map['customType'],
    createdAt:  DateTime.parse(map['createdAt']),
    updatedAt:  map['updateAt'] != null ? DateTime.parse(map['updateAt']) : null,
    );
}
Map<String,dynamic> toMap(){
  return {
    'id':id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    'name':name,
    'description':description,
    'todoType':todoType.toString(),
    'isCompleted':isCompleted? 1:0,
    'customType':customType,
    'createdAt':createdAt.toIso8601String(),
    'updatedAt':updatedAt?.toIso8601String(),
  };
}
 TodoModel copyWith({
    int? id,
    String? name,
    String? description,
    bool? isCompleted,
    TodoType? todoType,
    String? customType,
  }) {
    return TodoModel(
      name: name ?? this.name,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      todoType: todoType ?? this.todoType,
      customType: customType ?? this.customType,
       createdAt: createdAt,
    );
}}

extension AddMethod on DateTime{
  String format(){
    return DateFormat('dd MMM,yyyy hh:mm a').format(this);
  }
}