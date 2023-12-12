part of 'count_description_bloc.dart';

final class CountDescriptionState extends Equatable {
  const CountDescriptionState({this.descriptionLength = 0});

  final int descriptionLength;

  CountDescriptionState copyWith({
    int? descriptionLength,
  }) {
    return CountDescriptionState(descriptionLength: descriptionLength ?? this.descriptionLength);
  }

  @override
  List<Object?> get props => [descriptionLength];
}
