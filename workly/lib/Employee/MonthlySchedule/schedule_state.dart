part of 'schedule_cubit.dart';

abstract class ScheduleState  {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Map<String, List<String>> events;

  const ScheduleLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object> get props => [message];
}
