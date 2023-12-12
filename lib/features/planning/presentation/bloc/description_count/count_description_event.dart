part of 'count_description_bloc.dart';

sealed class CountDescriptionEvent extends Equatable {
  const CountDescriptionEvent();

  @override
  List<Object> get props => [];
}

final class ChangeDescriptionLength extends CountDescriptionEvent {
  const ChangeDescriptionLength(this.descriptionLength);

  final int descriptionLength;

  @override
  List<Object> get props => [descriptionLength];
}
