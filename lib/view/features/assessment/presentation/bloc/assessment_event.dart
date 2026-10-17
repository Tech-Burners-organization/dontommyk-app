part of 'assessment_bloc.dart';

sealed class AssessmentEvent extends Equatable {
  const AssessmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchAssessmentEvent extends AssessmentEvent {
  const FetchAssessmentEvent();
}

class SelectAnswerEvent extends AssessmentEvent {
  final int questionIndex;
  final int optionIndex;

  const SelectAnswerEvent({
    required this.questionIndex,
    required this.optionIndex,
  });

  @override
  List<Object?> get props => [questionIndex, optionIndex];
}

class NextQuestionEvent extends AssessmentEvent {
  const NextQuestionEvent();
}

class PreviousQuestionEvent extends AssessmentEvent {
  const PreviousQuestionEvent();
}

class SubmitAssessmentEvent extends AssessmentEvent {
  const SubmitAssessmentEvent();
}

