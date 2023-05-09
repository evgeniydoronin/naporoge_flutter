part of 'todo_bloc.dart';

class TodoState extends Equatable {

  const TodoState({this.tabStatus = true});

  final bool tabStatus;

  TodoState changeTab() {
    return TodoState(tabStatus: !tabStatus);
  }

  @override
  List<Object?> get props => [tabStatus];
}
