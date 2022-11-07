import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_auth_client/src/todos/todos.dart';

class MockTodosRepository extends Mock implements TodosRepository {}

void main() {
  group('TodosCubit', () {
    late MockTodosRepository mockApi;
    late TodosCubit Function([TodosState]) genTodosCubit;

    setUp(() {
      mockApi = MockTodosRepository();
      genTodosCubit = ([TodosState? initialState]) => TodosCubit(
            mockApi,
            initialState ?? const TodosState(),
          );
    });

    test('initial state is TodosState', () {
      expect(genTodosCubit().state, equals(const TodosState()));
    });

    group('getTodos()', () {
      blocTest<TodosCubit, TodosState>(
        'emits success when invoked',
        build: () => genTodosCubit(),
        act: (bloc) async {
          when(() => mockApi.getTodos('my token'))
              .thenAnswer((_) async => const [
                    Todo(
                      id: '1',
                      title: 'Todo title 1',
                      isComplete: false,
                      description: 'Todo description',
                      dueDate: '2022-11-11',
                    ),
                    Todo(
                      id: '2',
                      title: 'Todo title 2',
                      isComplete: true,
                      description: 'Todo description',
                      dueDate: '2022-11-13',
                    )
                  ]);

          await bloc.getTodos('my token');
        },
        expect: () => [
          const TodosState(status: TodosRequest.requestInProgress),
          const TodosState(status: TodosRequest.requestSuccess, todos: [
            Todo(
              id: '1',
              title: 'Todo title 1',
              isComplete: false,
              description: 'Todo description',
              dueDate: '2022-11-11',
            ),
            Todo(
              id: '2',
              title: 'Todo title 2',
              isComplete: true,
              description: 'Todo description',
              dueDate: '2022-11-13',
            )
          ]),
        ],
      );

      blocTest(
        'emits failure when invoked',
        build: () => genTodosCubit(),
        act: (bloc) async {
          when(() => mockApi.getTodos('my token'))
              .thenThrow(Exception('error'));

          await bloc.getTodos('my token');
        },
        expect: () => [
          const TodosState(status: TodosRequest.requestInProgress),
          const TodosState(status: TodosRequest.requestFailure),
        ],
      );
    });

    group('createTodo()', () {
      blocTest<TodosCubit, TodosState>(
        'emits success when invoked',
        build: () => genTodosCubit(),
        act: (bloc) async {
          when(() => mockApi.createTodo(
                token: 'my token',
                title: 'todo title 1',
                dueDate: '2022-11-13',
                description: 'todo description',
              )).thenAnswer((_) async => const Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
                dueDate: '2022-11-13',
                description: 'todo description',
              ));

          await bloc.createTodo(
            token: 'my token',
            title: 'todo title 1',
            dueDate: '2022-11-13',
            description: 'todo description',
          );
        },
        expect: () => [
          const TodosState(formStatus: TodosRequest.requestInProgress),
          const TodosState(formStatus: TodosRequest.requestSuccess, todos: [
            Todo(
              id: '1',
              title: 'todo title 1',
              isComplete: false,
              dueDate: '2022-11-13',
              description: 'todo description',
            ),
          ]),
        ],
      );

      blocTest<TodosCubit, TodosState>(
        'emits failure when invoked',
        build: () => genTodosCubit(),
        act: (bloc) async {
          when(() => mockApi.createTodo(
                token: 'my token',
                title: 'todo title 1',
                dueDate: '2022-11-13',
                description: 'todo description',
              )).thenThrow(Exception('error'));

          await bloc.createTodo(
            token: 'my token',
            title: 'todo title 1',
            dueDate: '2022-11-13',
            description: 'todo description',
          );
        },
        expect: () => [
          const TodosState(formStatus: TodosRequest.requestInProgress),
          const TodosState(formStatus: TodosRequest.requestFailure),
        ],
      );
    });

    group('updateTodo()', () {
      blocTest<TodosCubit, TodosState>(
        'emits success when invoked',
        build: () => genTodosCubit(const TodosState(
          todos: [
            Todo(
              id: '1',
              title: 'todo title 1',
              isComplete: false,
              dueDate: '2022-11-13',
              description: 'todo description',
            ),
          ],
        )),
        act: (bloc) async {
          when(() => mockApi.updateTodo(
                token: 'my token',
                todo: const Todo(
                  id: '1',
                  title: 'todo title 1 updated',
                  isComplete: true,
                  dueDate: '2022-11-13 updated',
                  description: 'todo description updated',
                ),
              )).thenAnswer((_) async => const Todo(
                id: '1',
                title: 'todo title 1 updated',
                isComplete: true,
                dueDate: '2022-11-13 updated',
                description: 'todo description updated',
              ));

          await bloc.updateTodo(
              token: 'my token',
              todo: const Todo(
                id: '1',
                title: 'todo title 1 updated',
                isComplete: true,
                dueDate: '2022-11-13 updated',
                description: 'todo description updated',
              ));
        },
        expect: () => [
          const TodosState(
            formStatus: TodosRequest.requestInProgress,
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
                dueDate: '2022-11-13',
                description: 'todo description',
              ),
            ],
          ),
          const TodosState(
            formStatus: TodosRequest.requestSuccess,
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1 updated',
                isComplete: true,
                dueDate: '2022-11-13 updated',
                description: 'todo description updated',
              )
            ],
          ),
        ],
      );

      blocTest<TodosCubit, TodosState>(
        'emits failure when invoked',
        build: () => genTodosCubit(const TodosState(
          todos: [
            Todo(
              id: '1',
              title: 'todo title 1',
              isComplete: false,
            ),
          ],
        )),
        act: (bloc) async {
          when(() => mockApi.updateTodo(
                token: 'my token',
                todo: const Todo(
                  id: '1',
                  title: 'todo title 1 updated',
                  isComplete: true,
                ),
              )).thenThrow(Exception('error'));

          await bloc.updateTodo(
              token: 'my token',
              todo: const Todo(
                id: '1',
                title: 'todo title 1 updated',
                isComplete: true,
              ));
        },
        expect: () => [
          const TodosState(
            formStatus: TodosRequest.requestInProgress,
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
          const TodosState(
            formStatus: TodosRequest.requestFailure,
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
        ],
      );
    });

    group('deleteTodo()', () {
      blocTest<TodosCubit, TodosState>(
        'emits success when invoked',
        build: () => genTodosCubit(const TodosState(
          todos: [
            Todo(
              id: '1',
              title: 'todo title 1',
              isComplete: false,
            ),
          ],
        )),
        act: (bloc) async {
          when(() => mockApi.deleteTodo(
                token: 'my token',
                id: '1',
              )).thenAnswer((_) async => '1');

          await bloc.deleteTodo(
            token: 'my token',
            id: '1',
          );
        },
        expect: () => [
          const TodosState(
            deleteItemStatus: TodosRequest.requestInProgress,
            itemsToDelete: {'1'},
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
          const TodosState(
            deleteItemStatus: TodosRequest.requestSuccess,
            itemsToDelete: {},
            todos: [],
          ),
        ],
      );

      blocTest(
        'emits failure when invoked',
        build: () => genTodosCubit(const TodosState(
          todos: [
            Todo(
              id: '1',
              title: 'todo title 1',
              isComplete: false,
            ),
          ],
        )),
        act: (bloc) async {
          when(() => mockApi.deleteTodo(
                token: 'my token',
                id: '1',
              )).thenThrow(Exception('error'));

          await bloc.deleteTodo(
            token: 'my token',
            id: '1',
          );
        },
        expect: () => [
          const TodosState(
            deleteItemStatus: TodosRequest.requestInProgress,
            itemsToDelete: {'1'},
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
          const TodosState(
            deleteItemStatus: TodosRequest.requestFailure,
            itemsToDelete: {},
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
          const TodosState(
            deleteItemStatus: TodosRequest.unknown,
            itemsToDelete: {},
            todos: [
              Todo(
                id: '1',
                title: 'todo title 1',
                isComplete: false,
              ),
            ],
          ),
        ],
      );
    });
  });
}
