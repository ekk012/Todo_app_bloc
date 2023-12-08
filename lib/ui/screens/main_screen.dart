import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../bloc/task_state.dart';
import '../../models/task.dart';
import '../widgets/task_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TextEditingController textInputTitleController;
  late TextEditingController textInputUserIdController;

  @override
  void initState() {
    super.initState();

    textInputTitleController = TextEditingController();
    textInputUserIdController = TextEditingController();
  }

  @override
  void dispose() {
    textInputTitleController.dispose();
    textInputUserIdController.dispose();
    super.dispose();
  }

  Future<Task?> _openDialog(int lastId) {
    textInputTitleController.text = '';
    textInputUserIdController.text = '';
    return showDialog<Task>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0XFFfeddaa),
              title: TextField(
                  controller: textInputTitleController,
                  decoration: const InputDecoration(
                      fillColor: Color(0XFF322a1d),
                      hintText: 'Title',
                      border: InputBorder.none)),
              content: TextField(
                  controller: textInputUserIdController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                      hintText: 'User ID',
                      border: InputBorder.none,
                      filled: true)),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: (() {
                      if (textInputTitleController.text != '' &&
                          textInputUserIdController.text != '') {
                        Navigator.of(context).pop(Task(
                            id: lastId + 1,
                            userId: int.parse(textInputUserIdController.text),
                            title: textInputTitleController.text));
                      }
                    }),
                    child: const Text('Add',
                        style: TextStyle(color: Color(0xFF322a1d))))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    int? lastId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          print('Current state: $state');

          if (state is TasksLoading) {
            return const CircularProgressIndicator();
          } else if (state is TasksLoaded) {
            if (state.tasks.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ...state.tasks.map(
                        (task) => InkWell(
                          onTap: (() {
                            context.read<TasksBloc>().add(UpdateTask(
                                task: task.copyWith(
                                    isComplete: !task.isComplete)));
                          }),
                          child: TaskWidget(
                            task: task,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No Task Found'));
            }
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded && state.tasks.isNotEmpty) {
            lastId = state.tasks.last.id;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Task Updated!'),
            ));
          }
        },
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: const Color(0xFF322a1d),
          onPressed: () async {
            Task? task = await _openDialog(lastId ?? 0);
            if (task != null) {
              context.read<TasksBloc>().add(
                    AddTask(task: task),
                  );
            }
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
