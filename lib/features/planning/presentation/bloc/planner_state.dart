part of 'planner_bloc.dart';

abstract class PlanningState {}

class PlanningInitial extends PlanningState {}

class PlanningDateRangeState extends PlanningState {
  final DateTime date;

  PlanningDateRangeState(this.date);
}

class PlanningCaseTitleState extends PlanningState {
  final String caseId;
  final String caseTitle;

  PlanningCaseTitleState(this.caseId, this.caseTitle);
}

class PlanningCaseDescriptionState extends PlanningState {
  final String caseDescription;

  PlanningCaseDescriptionState(this.caseDescription);
}
