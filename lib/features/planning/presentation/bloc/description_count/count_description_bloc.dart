import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'count_description_event.dart';

part 'count_description_state.dart';

class CountDescriptionBloc extends Bloc<CountDescriptionEvent, CountDescriptionState> {
  CountDescriptionBloc() : super(const CountDescriptionState()) {
    on<ChangeDescriptionLength>(_onCountDescriptionEvent);
  }

  void _onCountDescriptionEvent(
    ChangeDescriptionLength event,
    Emitter<CountDescriptionState> emit,
  ) {
    final descriptionLength = event.descriptionLength;
    emit(state.copyWith(descriptionLength: descriptionLength));
  }
}
