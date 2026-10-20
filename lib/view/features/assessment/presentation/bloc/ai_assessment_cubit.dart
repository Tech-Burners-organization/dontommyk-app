import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tommy/core/result/result.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_model.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_ai_assessment_usecase.dart';
import 'package:tommy/view/features/assessment/domain/usecases/submit_ai_assessment_usecase.dart';

sealed class AiAssessmentState extends Equatable {
  const AiAssessmentState();

  @override
  List<Object?> get props => [];
}

class AiAssessmentInitial extends AiAssessmentState {
  const AiAssessmentInitial();
}

class AiAssessmentLoading extends AiAssessmentState {
  const AiAssessmentLoading();
}

class AiAssessmentLoaded extends AiAssessmentState {
  final AssessmentInfo assessment;
  final List<AssessmentQuestion> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers; // questionIndex -> optionIndex
  final bool isSubmitting;

  const AiAssessmentLoaded({
    required this.assessment,
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.isSubmitting = false,
  });

  AssessmentQuestion get currentQuestion => questions[currentIndex];
  int? get selectedOptionIndex => selectedAnswers[currentIndex];
  bool get hasSelectedCurrent => selectedAnswers.containsKey(currentIndex);
  bool get isLastQuestion => currentIndex == questions.length - 1;

  AiAssessmentLoaded copyWith({
    AssessmentInfo? assessment,
    List<AssessmentQuestion>? questions,
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    bool? isSubmitting,
  }) {
    return AiAssessmentLoaded(
      assessment: assessment ?? this.assessment,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        assessment,
        questions,
        currentIndex,
        selectedAnswers,
        isSubmitting,
      ];
}

class AiAssessmentSubmitSuccess extends AiAssessmentState {
  final String message;

  const AiAssessmentSubmitSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AiAssessmentError extends AiAssessmentState {
  final String message;

  const AiAssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class AiAssessmentCubit extends Cubit<AiAssessmentState> {
  final GetAiAssessmentUseCase getAiAssessmentUseCase;
  final SubmitAiAssessmentUseCase submitAiAssessmentUseCase;
  String _targetId = '';

  AiAssessmentCubit({
    required this.getAiAssessmentUseCase,
    required this.submitAiAssessmentUseCase,
  }) : super(const AiAssessmentInitial());

  Future<void> loadAiAssessment(String assessmentId) async {
    _targetId = assessmentId;
    if (assessmentId.trim().isEmpty) {
      emit(const AiAssessmentError('Assessment ID is missing.'));
      return;
    }

    emit(const AiAssessmentLoading());
    final result = await getAiAssessmentUseCase(assessmentId);

    switch (result) {
      case ResultSuccess(data: final response):
        if (response.questions.isEmpty) {
          emit(const AiAssessmentError('No assessment questions found.'));
        } else {
          emit(AiAssessmentLoaded(
            assessment: response.assessment,
            questions: response.questions,
            currentIndex: 0,
            selectedAnswers: const {},
          ));
        }
      case ResultFailure(failure: final failure):
        emit(AiAssessmentError(failure.message));
    }
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    if (state is! AiAssessmentLoaded) return;
    final currentState = state as AiAssessmentLoaded;

    final updated = Map<int, int>.from(currentState.selectedAnswers);
    updated[questionIndex] = optionIndex;

    emit(currentState.copyWith(selectedAnswers: updated));
  }

  void nextQuestion() {
    if (state is! AiAssessmentLoaded) return;
    final currentState = state as AiAssessmentLoaded;

    if (currentState.currentIndex < currentState.questions.length - 1) {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
      ));
    }
  }

  void previousQuestion() {
    if (state is! AiAssessmentLoaded) return;
    final currentState = state as AiAssessmentLoaded;

    if (currentState.currentIndex > 0) {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex - 1,
      ));
    }
  }

  Future<void> submit() async {
    if (state is! AiAssessmentLoaded) return;
    final currentState = state as AiAssessmentLoaded;

    if (currentState.selectedAnswers.length < currentState.questions.length) {
      emit(const AiAssessmentError(
          'Please answer all questions before submitting.'));
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

    final targetId = _targetId.isNotEmpty
        ? _targetId
        : (currentState.assessment.id.isNotEmpty
            ? currentState.assessment.id
            : (currentState.questions.isNotEmpty
                ? currentState.questions.first.assessmentId
                : ''));

    final payload = {
      'answers': answers.map((a) => a.toJson()).toList(),
    };
    debugPrint('[AiAssessmentCubit] Submitting AI Assessment Body (targetId: $targetId):\n${const JsonEncoder.withIndent('  ').convert(payload)}');

    final result = await submitAiAssessmentUseCase(
      SubmitAiAssessmentParams(
        assessmentId: targetId,
        answers: answers,
      ),
    );

    switch (result) {
      case ResultSuccess(data: final message):
        emit(AiAssessmentSubmitSuccess(message));
      case ResultFailure(failure: final failure):
        emit(currentState.copyWith(isSubmitting: false));
        emit(AiAssessmentError(failure.message));
    }
  }
}

