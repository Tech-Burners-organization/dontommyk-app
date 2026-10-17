import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/route/app_route.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_snacbar.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_bloc.dart';

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocConsumer<AssessmentBloc, AssessmentState>(
            listener: (context, state) {
              if (state is AssessmentSubmitSuccess) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  isSuccess: true,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoute.dashboard,
                  (route) => false,
                );
              } else if (state is AssessmentError) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  isSuccess: false,
                );
              }
            },
            builder: (context, state) {
              if (state is AssessmentLoading || state is AssessmentInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD48B3B),
                  ),
                );
              }

              if (state is AssessmentError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 60,
                        ),
                        SizedBox(height: 16.h),
                        CommonText(
                          text: state.message,
                          color: Colors.white,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        CommonButton(
                          titleText: 'Retry',
                          titleColor: Colors.black,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          onTap: () {
                            context.read<AssessmentBloc>().add(
                              const FetchAssessmentEvent(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is AssessmentLoaded) {
                final currentQuestion = state.currentQuestion;
                final totalQuestions = state.questions.length;
                final currentNumber = state.currentIndex + 1;
                final progress = currentNumber / totalQuestions;
                final selectedOptionIndex = state.selectedOptionIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white38),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (state.currentIndex > 0) {
                                  context.read<AssessmentBloc>().add(
                                    const PreviousQuestionEvent(),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Question $currentNumber ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'of $totalQuestions',
                                            style: const TextStyle(
                                              color: Colors.white60,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (currentQuestion.category.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0x33D48B3B),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: const Color(0x66D48B3B),
                                          ),
                                        ),
                                        child: CommonText(
                                          text: currentQuestion.category
                                              .toUpperCase(),
                                          color: const Color(0xFFFBE1A6),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white12,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFD48B3B),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28.h),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF261911),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: CommonText(
                          text: currentQuestion.question,
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          maxLines: 4,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: currentQuestion.options.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, optIndex) {
                            final option = currentQuestion.options[optIndex];
                            final isSelected = selectedOptionIndex == optIndex;

                            return GestureDetector(
                              onTap: () {
                                context.read<AssessmentBloc>().add(
                                  SelectAnswerEvent(
                                    questionIndex: state.currentIndex,
                                    optionIndex: optIndex,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0x33D48B3B)
                                      : Colors.white.withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFD48B3B)
                                        : Colors.white12,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFFD48B3B)
                                              : Colors.white38,
                                          width: isSelected ? 7 : 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: CommonText(
                                        text: option.text,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          if (state.currentIndex > 0) ...[
                            Expanded(
                              child: CommonButton(
                                titleText: 'Previous',
                                titleColor: Colors.white,
                                buttonColor: const Color(0xFF261911),
                                borderColor: Colors.white12,
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  context.read<AssessmentBloc>().add(
                                    const PreviousQuestionEvent(),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),
                          ],
                          Expanded(
                            flex: state.currentIndex == 0 ? 2 : 1,
                            child: CommonButton(
                              isLoading: state.isSubmitting,
                              titleText: state.isLastQuestion
                                  ? 'Complete'
                                  : 'Next Question',
                              titleColor: Colors.black,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              trailingIcon: Icon(
                                state.isLastQuestion
                                    ? Icons.check
                                    : Icons.chevron_right,
                                color: Colors.black,
                              ),
                              onTap: () {
                                if (!state.hasSelectedCurrent) {
                                  showAppSnackBar(
                                    context,
                                    message:
                                        'Please select an answer to continue',
                                    isSuccess: false,
                                  );
                                  return;
                                }

                                if (state.isLastQuestion) {
                                  context.read<AssessmentBloc>().add(
                                    const SubmitAssessmentEvent(),
                                  );
                                } else {
                                  context.read<AssessmentBloc>().add(
                                    const NextQuestionEvent(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
