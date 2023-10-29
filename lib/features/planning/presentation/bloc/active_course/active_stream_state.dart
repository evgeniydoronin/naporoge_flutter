part of 'active_stream_bloc.dart';

final class ActiveStreamState extends Equatable {
  final NPStream? npStream;
  final int studentsStreams;

  const ActiveStreamState({this.npStream, this.studentsStreams = 0});

  ActiveStreamState copyWith({
    NPStream? npStream,
    int? studentsStreams,
  }) {
    return ActiveStreamState(
      npStream: npStream ?? this.npStream,
      studentsStreams: studentsStreams ?? this.studentsStreams,
    );
  }

  @override
  List<Object> get props => [npStream ?? 'not stream found', studentsStreams];
}
