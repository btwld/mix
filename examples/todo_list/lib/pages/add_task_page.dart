import 'package:flutter/material.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/pages/controller/task_controller.dart';
import 'package:todo_list/style/design_tokens.dart';

import '../style/components/button.dart';

const _colors = ColorTokens();
const _textStyles = TextStyleTokens();

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.controller});

  final TasksController controller;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: _colors.surface.resolve(context),
        appBar: AppBar(
          backgroundColor: _colors.surface.resolve(context),
          title: Text(
            'Create Task',
            style: _textStyles.heading2.resolve(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => _value = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Add a task',
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: TodoButton(
                  text: 'Save',
                  onPressed: () {
                    if (_value.isEmpty) {
                      // showToDoDialog(context);
                      return;
                    }
                    setState(() {
                      widget.controller.addTask(
                        Task(
                          text: _value,
                          value: false,
                        ),
                      );
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
