import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_reminder_app/utils/Extantion.dart';
import 'package:task_reminder_app/utils/Utility.dart';
import 'package:uuid/uuid.dart';
import '../Controller/Taskbloc/task_bloc.dart';
import '../Model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;
  Recurrence _selectedRecurrence = Recurrence.none;

  void _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _addTask() {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        reminderTime: _selectedDateTime!,
        recurrence: _selectedRecurrence,
      );
      debugPrint(newTask.toString());
      context.read<TaskBloc>().add(AddTask(newTask));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a date.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title*",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _titleController,
                decoration: Utility.mytextfielddecoration("Task Title", null),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              8.toSpace,
              const Text(
                "Description*",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: Utility.mytextfielddecoration('Description', null),
              ),
              8.toSpace,
              const Text(
                "Select Date N Time*",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 48,
                child: TextFormField(
                  scrollPadding: EdgeInsets.zero,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedDateTime == null
                        ? 'Please Select Date'
                        : Utility().formatDateTime(_selectedDateTime),
                  ),
                  decoration: Utility.mytextfielddecoration(
                    'Reminder Time',
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        size: 20,
                      ),
                      onPressed: () => _selectDateTime(context),
                    ),
                  ),
                  onTap: () => _selectDateTime(context),
                ),
              ),
              8.toSpace,
              const Text('Recurrence:', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 16, // Spacing between radio buttons
                children: Recurrence.values.map((recurrence) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<Recurrence>(
                        value: recurrence,
                        groupValue: _selectedRecurrence,
                        onChanged: (value) {
                          setState(() {
                            _selectedRecurrence = value!;
                          });
                        },
                      ),
                      Text(
                        recurrence
                            .toString()
                            .split('.')
                            .last
                            .replaceFirst('none', 'None'),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const Spacer(),
              MaterialButton(
                height: 48,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue,
                onPressed: _addTask,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Add Task",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
