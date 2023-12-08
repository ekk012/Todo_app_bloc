import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/ui/screens/main_screen.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'data/task_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
          useMaterial3: true,
        
         ),
      home: RepositoryProvider(
        create: (context) => TaskRepository(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => TasksBloc(
                      RepositoryProvider.of<TaskRepository>(context),
                    )..add(const LoadTask()))
          ],
          child: const MainScreen(title: 'Tasks',),
        ),
      ),
    );
  }
}