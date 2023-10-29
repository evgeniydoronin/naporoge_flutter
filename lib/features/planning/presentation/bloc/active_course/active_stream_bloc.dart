import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import '../../../../../core/services/db_client/isar_service.dart';
import '../../../domain/entities/stream_entity.dart';

part 'active_stream_event.dart';

part 'active_stream_state.dart';

class ActiveStreamBloc extends Bloc<ActiveStreamEvent, ActiveStreamState> {
  ActiveStreamBloc() : super(const ActiveStreamState()) {
    on<ActiveStreamChanged>(_onActiveStreamEvent);
  }

  void _onActiveStreamEvent(
    ActiveStreamChanged event,
    Emitter<ActiveStreamState> emit,
  ) async {
    final isarService = IsarService();
    final isar = await isarService.db;
    final List<NPStream> studentsStreams = await isar.nPStreams.where().findAll();

    emit(state.copyWith(npStream: event.npStream, studentsStreams: studentsStreams.length));
  }
}
