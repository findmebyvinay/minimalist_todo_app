import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:todoo_app/model/todo_model.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/todo_event.dart';
import '../../bloc/todo_state.dart';
import '../constant/app_theme.dart';

class AddTodoPage extends StatefulWidget {
  final TodoModel? todoToEdit;

  const AddTodoPage({
    Key? key,
    this.todoToEdit,
  }) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customTypeController = TextEditingController();
  
  bool _isEditing = false;
  TodoType _selectedType = TodoType.education;
  bool _showCustomTypeField = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.todoToEdit != null) {
      _isEditing = true;
      _nameController.text = widget.todoToEdit!.name;
      _descriptionController.text = widget.todoToEdit!.description;
      _selectedType = widget.todoToEdit!.todoType;
      
      if (widget.todoToEdit!.todoType == TodoType.other && widget.todoToEdit!.customType != null) {
        _showCustomTypeField = true;
        _customTypeController.text = widget.todoToEdit!.customType!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Add New Task'),
        elevation: 0,
      ),
      body: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoAdded || state is TodoUpdated) {
            Get.back();
          } else if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Task name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    prefixIcon: Icon(Icons.task_alt),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Task description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Task type field
                Text(
                  'Task Type',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Dropdown for task type
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TodoType>(
                      value: _selectedType,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: AppTheme.textPrimaryColor),
                      onChanged: (TodoType? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                          _showCustomTypeField = newValue == TodoType.other;
                        });
                      },
                      items: TodoType.values.map<DropdownMenuItem<TodoType>>((TodoType value) {
                        return DropdownMenuItem<TodoType>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppTheme.getTypeColor(value.index),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(_getTypeText(value)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                
                // Custom type field (shows only when "Other" is selected)
                if (_showCustomTypeField) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Type',
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) {
                      if (_selectedType == TodoType.other && (value == null || value.isEmpty)) {
                        return 'Please enter a custom type';
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Submit button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Update Task' : 'Add Task',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeText(TodoType type) {
    switch (type) {
      case TodoType.education:
        return 'Education';
      case TodoType.entertainment:
        return 'Entertainment';
      case TodoType.health:
        return 'Health';
      case TodoType.other:
        return 'Other';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
    final todo = TodoModel(
      id: _isEditing ? widget.todoToEdit!.id : null,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      isCompleted: _isEditing ? widget.todoToEdit!.isCompleted : false,
      todoType: _selectedType,
      customType: _selectedType == TodoType.other ? _customTypeController.text.trim() : null,
      createdAt: DateTime.now(),
      updatedAt: _isEditing ? DateTime.now() : null, // Set updatedAt for edits
    );

    if (_isEditing) {
      context.read<TodoBloc>().add(UpdateTodoEvent(todo));
      print('Updating: $todo');
    } else {
      context.read<TodoBloc>().add(AddTodoEvent(todo));
      print('Adding: $todo');
    }
  }
  }
}