import 'package:equatable/equatable.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';

abstract class ProgressState extends Equatable {
  final String period;

  const ProgressState({this.period = 'weekly'});

  @override
  List<Object?> get props => [period];
}

class ProgressInitial extends ProgressState {
  const ProgressInitial({super.period});
}

class ProgressLoading extends ProgressState {
  const ProgressLoading({super.period});
}

class ProgressLoaded extends ProgressState {
  final ProgressDataModel data;

  const ProgressLoaded({
    required this.data,
    super.period,
  });

  @override
  List<Object?> get props => [data, period];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError({
    required this.message,
    super.period,
  });

  @override
  List<Object?> get props => [message, period];
}

