part of 'active_stream_bloc.dart';

final class ActiveStreamState extends Equatable {
  final NPStream? npStream;
  final NPStream? activeNpStream;
  final int studentsStreams;

  const ActiveStreamState({this.npStream, this.activeNpStream, this.studentsStreams = 0});

  ActiveStreamState copyWith({
    NPStream? npStream,
    NPStream? activeNpStream,
    int? studentsStreams,
  }) {
    return ActiveStreamState(
      npStream: npStream ?? this.npStream,
      activeNpStream: activeNpStream ?? this.activeNpStream,
      studentsStreams: studentsStreams ?? this.studentsStreams,
    );
  }

  @override
  List<Object> get props =>
      [npStream ?? 'stream not found', activeNpStream ?? 'active stream not found', studentsStreams];
}
