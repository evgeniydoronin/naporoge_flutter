import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../data/sources/local/stream_local_storage.dart';
import '../../../domain/entities/stream_entity.dart';

part 'active_stream_event.dart';

part 'active_stream_state.dart';

class ActiveStreamBloc extends Bloc<ActiveStreamEvent, ActiveStreamState> {
  ActiveStreamBloc() : super(const ActiveStreamState()) {
    on<ActiveStreamChanged>(_onActiveStreamEvent);
    on<GetActiveStream>(_onGetActiveStream);
  }

  void _onActiveStreamEvent(
    ActiveStreamChanged event,
    Emitter<ActiveStreamState> emit,
  ) async {
    final isarService = IsarService();
    final streamLocalStorage = StreamLocalStorage();
    final isar = await isarService.db;
    final List<NPStream> studentsStreams = await isar.nPStreams.where().findAll();

    print('bloc ActiveStreamState: $studentsStreams');
    NPStream? activeNpStream = await streamLocalStorage.getActiveStream();

    emit(state.copyWith(
        npStream: event.npStream, activeNpStream: activeNpStream, studentsStreams: studentsStreams.length));
  }

  void _onGetActiveStream(
    GetActiveStream event,
    Emitter<ActiveStreamState> emit,
  ) async {
    final streamLocalStorage = StreamLocalStorage();
    NPStream? activeNpStream = await streamLocalStorage.getActiveStream();

    emit(state.copyWith(activeNpStream: activeNpStream));
  }
}
