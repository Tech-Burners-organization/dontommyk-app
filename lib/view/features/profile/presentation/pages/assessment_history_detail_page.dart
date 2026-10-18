import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_detail_model.dart';
import 'package:tommy/view/features/assessment/data/models/assessment_history_model.dart';
import 'package:tommy/view/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:tommy/view/features/assessment/domain/usecases/get_assessment_detail_usecase.dart';
import 'package:tommy/view/features/assessment/presentation/bloc/assessment_detail_cubit.dart';

class AssessmentHistoryDetailPage extends StatelessWidget {
  final String assessmentId;

  const AssessmentHistoryDetailPage({
    super.key,
    required this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    try {
      context.read<AssessmentDetailCubit>();
      return _AssessmentHistoryDetailView(assessmentId: assessmentId);
    } catch (_) {
      final repo = context.read<AssessmentRepository>();
      return BlocProvider(
        create: (_) => AssessmentDetailCubit(
          getAssessmentDetailUseCase: GetAssessmentDetailUseCase(repo),
        )..fetchDetail(assessmentId),
        child: _AssessmentHistoryDetailView(assessmentId: assessmentId),
      );
    }
  }
}

class _AssessmentHistoryDetailView extends StatefulWidget {
  final String assessmentId;

  const _AssessmentHistoryDetailView({required this.assessmentId});

  @override
  State<_AssessmentHistoryDetailView> createState() =>
      _AssessmentHistoryDetailViewState();
}

class _AssessmentHistoryDetailViewState
    extends State<_AssessmentHistoryDetailView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: BlocBuilder<AssessmentDetailCubit, AssessmentDetailState>(
          builder: (context, state) {
            return switch (state) {
              AssessmentDetailLoading() ||
              AssessmentDetailInitial() =>
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD48B3B),
                  ),
                ),
              AssessmentDetailError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          message.isNotEmpty
                              ? message
                              : 'Failed to load assessment details',
                          style: GoogleFonts.figtree(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Try Again'),
                          onPressed: () {
                            context
                                .read<AssessmentDetailCubit>()
                                .fetchDetail(widget.assessmentId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              AssessmentDetailLoaded(:final detail) =>
                _buildContent(context, detail),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AssessmentDetailModel detail) {
    final questions = detail.questions;

    if (questions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildAppBar(context, title: 'Assessment Detail', result: detail.result),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white12),
              ),
              child: const Icon(
                Icons.quiz_outlined,
                color: Colors.white38,
                size: 44,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Questions Found',
              style: GoogleFonts.figtree(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Details are not available for this assessment yet.',
              style: GoogleFonts.figtree(
                color: Colors.white54,
                fontSize: 13.sp,
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    }

    final safeIndex = _currentIndex.clamp(0, questions.length - 1);
    final question = questions[safeIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _buildAppBar(
            context,
            title:
                'Assessment History (${safeIndex + 1} of ${questions.length})',
            result: detail.result,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD48B3B)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFD48B3B)
                                .withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          question.category.toUpperCase(),
                          style: GoogleFonts.figtree(
                            color: const Color(0xFFD48B3B),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (question.obtainedScore != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF32C68A)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF32C68A)
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            'Score: ${question.obtainedScore}/${question.maxPossibleScore ?? 4}',
                            style: GoogleFonts.figtree(
                              color: const Color(0xFF32C68A),
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF261911),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      question.question,
                      style: GoogleFonts.figtree(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ...question.options.map((option) {
                    final isSelected = (question.selectedAnswer != null &&
                            question.selectedAnswer!.trim().toLowerCase() ==
                                option.text.trim().toLowerCase()) ||
                        (option.score == question.obtainedScore &&
                            question.selectedAnswer == null);

                    return _buildOptionTile(
                      optionText: option.text,
                      isSelected: isSelected,
                    );
                  }),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          _buildBottomBar(
            totalQuestions: questions.length,
            currentIndex: safeIndex,
            result: detail.result,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context, {
    required String title,
    AssessmentResultModel? result,
  }) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white38),
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.figtree(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (result != null)
          IconButton(
            tooltip: 'Score breakdown',
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD48B3B).withValues(alpha: 0.15),
                border: Border.all(
                  color: const Color(0xFFD48B3B).withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Color(0xFFD48B3B),
                size: 20,
              ),
            ),
            onPressed: () => _showScoreBreakdown(context, result),
          ),
      ],
    );
  }

  Widget _buildOptionTile({
    required String optionText,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFD48B3B).withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: isSelected ? const Color(0xFFD48B3B) : Colors.white12,
          width: isSelected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFFD48B3B)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD48B3B)
                    : Colors.white38,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    size: 13,
                    color: Colors.black,
                  )
                : null,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              optionText,
              style: GoogleFonts.figtree(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
          if (isSelected) ...[
            SizedBox(width: 8.w),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFD48B3B).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Selected',
                style: GoogleFonts.figtree(
                  color: const Color(0xFFD48B3B),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar({
    required int totalQuestions,
    required int currentIndex,
    AssessmentResultModel? result,
  }) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == totalQuestions - 1;

    return Row(
      children: [
        if (!isFirst) ...[
          Expanded(
            flex: 2,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = (_currentIndex - 1).clamp(0, totalQuestions - 1);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                  SizedBox(width: 4.w),
                  Text(
                    'Previous',
                    style: GoogleFonts.figtree(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          flex: 3,
          child: CommonButton(
            titleText: isLast ? 'Score Breakdown' : 'Next Question',
            titleColor: Colors.black,
            gradient: const LinearGradient(
              colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            trailingIcon: Icon(
              isLast ? Icons.analytics_outlined : Icons.chevron_right,
              color: Colors.black,
              size: 20,
            ),
            onTap: () {
              if (isLast) {
                if (result != null) {
                  _showScoreBreakdown(context, result);
                } else {
                  Navigator.pop(context);
                }
              } else {
                setState(() {
                  _currentIndex = (_currentIndex + 1).clamp(0, totalQuestions - 1);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void _showScoreBreakdown(
    BuildContext context,
    AssessmentResultModel result,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF1E1715),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assessment Result',
                    style: GoogleFonts.figtree(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD48B3B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD48B3B)),
                    ),
                    child: Text(
                      'Overall: ${result.overallScore}/100',
                      style: GoogleFonts.figtree(
                        color: const Color(0xFFD48B3B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildScoreRow('Leadership', result.leadershipScore),
              _buildScoreRow('Communication', result.communicationScore),
              _buildScoreRow('Behavioral', result.behavioralScore),
              _buildScoreRow('Emotional', result.emotionalScore),
              SizedBox(height: 24.h),
              CommonButton(
                titleText: 'Close',
                titleColor: Colors.black,
                gradient: const LinearGradient(
                  colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                ),
                onTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreRow(String dimension, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dimension,
                style: GoogleFonts.figtree(
                  color: Colors.white70,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$score/100',
                style: GoogleFonts.figtree(
                  color: const Color(0xFFD48B3B),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFD48B3B),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
