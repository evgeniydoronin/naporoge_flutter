part of 'planner_bloc.dart';

abstract class PlaningEvent {}

class PlaningSelectRangeEvent extends PlaningEvent {
  final DateTime startDate;

  PlaningSelectRangeEvent({required this.startDate});
}
