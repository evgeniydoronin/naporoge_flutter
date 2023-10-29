part of 'active_stream_bloc.dart';

sealed class ActiveStreamEvent extends Equatable {
  const ActiveStreamEvent();

  @override
  List<Object?> get props => [];
}

final class ActiveStreamChanged extends ActiveStreamEvent {
  final NPStream? npStream;
  final int? studentsStreams;

  const ActiveStreamChanged({this.npStream, this.studentsStreams});

  @override
  List<Object?> get props => [npStream ?? '', studentsStreams];
}
