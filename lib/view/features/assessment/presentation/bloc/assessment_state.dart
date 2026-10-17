part of 'assessment_bloc.dart';

sealed class AssessmentState extends Equatable {
  const AssessmentState();

  @override
  List<Object?> get props => [];
}

final class AssessmentInitial extends AssessmentState {
  const AssessmentInitial();
}

final class AssessmentLoading extends AssessmentState {
  const AssessmentLoading();
}

final class AssessmentLoaded extends AssessmentState {
  final AssessmentInfo assessment;
  final List<AssessmentQuestion> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers; // questionIndex -> optionIndex
  final bool isSubmitting;

  const AssessmentLoaded({
    required this.assessment,
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.isSubmitting = false,
  });

  AssessmentLoaded copyWith({
    AssessmentInfo? assessment,
    List<AssessmentQuestion>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    bool? isSubmitting,
  }) {
    return AssessmentLoaded(
      assessment: assessment ?? this.assessment,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  AssessmentQuestion get currentQuestion => questions[currentIndex];
  int? get selectedOptionIndex => selectedAnswers[currentIndex];
  bool get hasSelectedCurrent => selectedAnswers.containsKey(currentIndex);
  bool get isLastQuestion => currentIndex == questions.length - 1;

  @override
  List<Object?> get props => [
    assessment,
    questions,
    currentIndex,
    selectedAnswers,
    isSubmitting,
  ];
}

final class AssessmentSubmitSuccess extends AssessmentState {
  final String message;

  const AssessmentSubmitSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class AssessmentError extends AssessmentState {
  final String message;

  const AssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}

