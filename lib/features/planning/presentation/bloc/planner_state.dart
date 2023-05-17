part of 'planner_bloc.dart';

abstract class PlaningState {}

class PlaningInitial extends PlaningState {}

class PlaningGetDateRange extends PlaningState {
  final DateTime date;

  PlaningGetDateRange(this.date);
}
