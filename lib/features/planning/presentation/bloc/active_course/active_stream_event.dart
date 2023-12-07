part of 'active_stream_bloc.dart';

sealed class ActiveStreamEvent extends Equatable {
  const ActiveStreamEvent();

  @override
  List<Object?> get props => [];
}

final class ActiveStreamChanged extends ActiveStreamEvent {
  final NPStream? npStream;
  final NPStream? activeNpStream;
  final int? studentsStreams;

  const ActiveStreamChanged({this.npStream, this.activeNpStream, this.studentsStreams});

  @override
  List<Object?> get props => [npStream, activeNpStream, studentsStreams];
}

final class GetActiveStream extends ActiveStreamEvent {
  final NPStream? activeNpStream;

  const GetActiveStream({this.activeNpStream});

  @override
  List<Object?> get props => [activeNpStream];
}
