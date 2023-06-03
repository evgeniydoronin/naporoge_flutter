part of 'planner_bloc.dart';

abstract class PlanningEvent {}

class PlanningSelectRangeEvent extends PlanningEvent {
  final DateTime startDate;

  PlanningSelectRangeEvent({required this.startDate});
}

class PlanningCaseEvent extends PlanningEvent {
  final String caseId;
  final String caseTitle;

  PlanningCaseEvent({
    required this.caseId,
    required this.caseTitle,
  });
}

class PlanningCaseDescriptionEvent extends PlanningEvent {
  final String caseDescription;

  PlanningCaseDescriptionEvent({required this.caseDescription});
}
