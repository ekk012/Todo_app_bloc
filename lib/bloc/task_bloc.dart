

import 'package:bloc/bloc.dart';

import 'package:todo/bloc/task_event.dart';
import 'package:todo/bloc/task_state.dart';

import '../data/task_repository.dart';
import '../models/task.dart';


class TasksBloc extends Bloc<TaskEvent, TasksState> {
  final TaskRepository _taskRepository;

  TasksBloc(this._taskRepository) : super(TasksLoading()) {
    on<LoadTask>(_onLoadTask);
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TasksState> emit) async {
  emit(TasksLoading());
  try {
    final tasks = await _taskRepository.loadTasks();
    emit(TasksLoaded(tasks: tasks ));
  } catch (e) {
    emit(TasksError(e.toString())); // Provide a more specific error type if possible
  }
}

void _onAddTask(AddTask event, Emitter<TasksState> emit) {
  final state = this.state;
  if (state is TasksLoaded) {
    emit(TasksLoaded(tasks: [...state.tasks, event.task]));
  }
}

void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
  final state = this.state;
  if (state is TasksLoaded) {
    List<Task> tasks = state.tasks.where((task) {
    return task.id != event.task.id;
    }).toList();
    emit(TasksLoaded(tasks: tasks));
  }
}

void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
  final state = this.state;
  if (state is TasksLoaded) {
    List<Task> tasks = state.tasks.map((task) {
      return task.id == event.task.id ? event.task : task;
    }).toList();
    emit(TasksLoaded(tasks: tasks));
  }
}

}