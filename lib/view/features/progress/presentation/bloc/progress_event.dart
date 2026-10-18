import 'package:equatable/equatable.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class FetchProgressEvent extends ProgressEvent {
  final String period;

  const FetchProgressEvent({this.period = 'weekly'});

  @override
  List<Object?> get props => [period];
}

class ChangePeriodEvent extends ProgressEvent {
  final String period;

  const ChangePeriodEvent(this.period);

  @override
  List<Object?> get props => [period];
}

