import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/core/usecase/usecase.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_initial_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/submit_initial_assessment_usecase.dart';

part 'assessment_event.dart';
part 'assessment_state.dart';

class AssessmentBloc extends Bloc<AssessmentEvent, AssessmentState> {
  final GetInitialAssessmentUseCase getInitialAssessmentUseCase;
  final SubmitInitialAssessmentUseCase submitInitialAssessmentUseCase;

  AssessmentBloc({
    required this.getInitialAssessmentUseCase,
    required this.submitInitialAssessmentUseCase,
  }) : super(const AssessmentInitial()) {
    on<FetchAssessmentEvent>(_onFetchAssessment);
    on<SelectAnswerEvent>(_onSelectAnswer);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<SubmitAssessmentEvent>(_onSubmitAssessment);
  }

  Future<void> _onFetchAssessment(
    FetchAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    emit(const AssessmentLoading());
    final result = await getInitialAssessmentUseCase(const NoParams());

    switch (result) {
      case ResultSuccess(data: final response):
        if (response.questions.isEmpty) {
          emit(const AssessmentError('No assessment questions found.'));
        } else {
          emit(AssessmentLoaded(
            assessment: response.assessment,
            questions: response.questions,
            currentIndex: 0,
            selectedAnswers: const {},
          ));
        }
      case ResultFailure(failure: final failure):
        emit(AssessmentError(failure.message));
    }
  }

  void _onSelectAnswer(
    SelectAnswerEvent event,
    Emitter<AssessmentState> emit,
  ) {
    if (state is! AssessmentLoaded) return;
    final currentState = state as AssessmentLoaded;

    final updated = Map<int, int>.from(currentState.selectedAnswers);
    updated[event.questionIndex] = event.optionIndex;

    emit(currentState.copyWith(selectedAnswers: updated));
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<AssessmentState> emit,
  ) {
    if (state is! AssessmentLoaded) return;
    final currentState = state as AssessmentLoaded;

    if (currentState.currentIndex < currentState.questions.length - 1) {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
      ));
    }
  }

  void _onPreviousQuestion(
    PreviousQuestionEvent event,
    Emitter<AssessmentState> emit,
  ) {
    if (state is! AssessmentLoaded) return;
    final currentState = state as AssessmentLoaded;

    if (currentState.currentIndex > 0) {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex - 1,
      ));
    }
  }

  Future<void> _onSubmitAssessment(
    SubmitAssessmentEvent event,
    Emitter<AssessmentState> emit,
  ) async {
    if (state is! AssessmentLoaded) return;
    final currentState = state as AssessmentLoaded;

    // Check if all questions are answered
    if (currentState.selectedAnswers.length < currentState.questions.length) {
      emit(const AssessmentError('Please answer all questions before submitting.'));
      // Restore loaded state
      emit(currentState);
      return;
    }

    emit(currentState.copyWith(isSubmitting: true));

    final answers = <AssessmentAnswer>[];
    for (int i = 0; i < currentState.questions.length; i++) {
      final q = currentState.questions[i];
      final optionIndex = currentState.selectedAnswers[i] ?? 0;
      final option = q.options[optionIndex];

      answers.add(AssessmentAnswer(
        questionId: q.id,
        answer: option.text,
      ));
    }

    final benchmarkId = currentState.assessment.benchmarkId.isNotEmpty
        ? currentState.assessment.benchmarkId
        : (currentState.questions.isNotEmpty
            ? currentState.questions.first.benchmarkId
            : '');

    final result = await submitInitialAssessmentUseCase(
      SubmitInitialAssessmentParams(
        assessmentId: currentState.assessment.id,
        benchmarkId: benchmarkId,
        answers: answers,
      ),
    );

    switch (result) {
      case ResultSuccess(data: final message):
        emit(AssessmentSubmitSuccess(message));
      case ResultFailure(failure: final failure):
        emit(currentState.copyWith(isSubmitting: false));
        emit(AssessmentError(failure.message));
    }
  }
}

