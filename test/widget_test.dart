import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/bloc/task_bloc.dart';
import 'package:todo/bloc/task_event.dart';
import 'package:todo/bloc/task_state.dart';
import 'package:todo/data/task_repository.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group('TasksBloc', () {
    late TaskRepository taskRepository;
    late TasksBloc tasksBloc;

    setUp(() {
      taskRepository = MockTaskRepository();
      tasksBloc = TasksBloc(taskRepository);
    });

    test('initial state is TaskLoading', () {
      expect(tasksBloc.state, TasksLoading());
    });

    blocTest<TasksBloc, TasksState>(
      'emits [TasksLoading, TasksLoaded] when LoadTasks is added',
      build: () {
        when(taskRepository.loadTasks()).thenAnswer((_) async => []);
        return TasksBloc(taskRepository);
      },
      act: (bloc) => bloc.add(LoadTask()),
      expect: () => [
        TasksLoading(),
        TasksLoaded(tasks: []),
      ],
    );
  });
}
