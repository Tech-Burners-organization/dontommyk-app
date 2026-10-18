import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/features/progress/data/models/progress_model.dart';
import 'package:tommy/view/features/progress/domain/repositories/progress_repository.dart';
import 'package:tommy/view/features/progress/domain/usecases/get_progress_usecase.dart';
import 'package:tommy/view/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:tommy/view/features/progress/presentation/bloc/progress_event.dart';
import 'package:tommy/view/features/progress/presentation/bloc/progress_state.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressBloc(
        getProgressUseCase:
            GetProgressUseCase(context.read<ProgressRepository>()),
      )..add(const FetchProgressEvent(period: 'weekly')),
      child: const _ProgressPageView(),
    );
  }
}

class _ProgressPageView extends StatelessWidget {
  const _ProgressPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<ProgressBloc, ProgressState>(
            builder: (context, state) {
              if (state is ProgressLoading || state is ProgressInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD48B3B),
                  ),
                );
              }

              if (state is ProgressError) {
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
                            context.read<ProgressBloc>().add(
                              FetchProgressEvent(period: state.period),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ProgressLoaded) {
                final data = state.data;
                final currentPeriod = state.period;

                return RefreshIndicator(
                  color: const Color(0xFFD48B3B),
                  backgroundColor: const Color(0xFF140D0B),
                  onRefresh: () async {
                    context.read<ProgressBloc>().add(
                          FetchProgressEvent(period: currentPeriod),
                        );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        const CommonText(
                          text: 'Growth Tracker',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 8.h),
                        const CommonText(
                          text:
                              'Track your growth across key professional competencies by comparing your assessment results, development progress, and organizational alignment over time.',
                          color: Colors.white70,
                          fontSize: 14,
                          textAlign: TextAlign.left,
                          maxLines: 4,
                          lineHeight: 1.5,
                        ),
                        SizedBox(height: 30.h),

                        // Overall Score Chart Card
                        _buildOverallTrendCard(context, data, currentPeriod),
                        SizedBox(height: 20.h),

                        // Dimension Comparison Card
                        _buildDimensionComparison(data.dimensionComparison),
                        SizedBox(height: 20.h),

                        // AI Competency Analysis Card
                        if (data.aiCompetencyAnalysis.isNotEmpty)
                          _buildAiAnalysisCard(data.aiCompetencyAnalysis),

                        SizedBox(height: 40.h),
                      ],
                    ),
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

  Widget _buildOverallTrendCard(
    BuildContext context,
    ProgressDataModel data,
    String currentPeriod,
  ) {
    final trend = data.overallTrend;
    final change = trend.changePercent;
    final isPositive = change >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                text: 'Overall Score',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const CommonText(
                        text: 'Baseline',
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: isPositive
                                ? const Color(0xFF32C68A)
                                : Colors.redAccent,
                            size: 16,
                          ),
                          CommonText(
                            text: '${change.abs()}%',
                            color: isPositive
                                ? const Color(0xFF32C68A)
                                : Colors.redAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  PopupMenuButton<String>(
                    initialValue: currentPeriod,
                    color: const Color(0xFF241C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white12),
                    ),
                    onSelected: (period) {
                      context.read<ProgressBloc>().add(
                            ChangePeriodEvent(period),
                          );
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'weekly',
                        child: CommonText(
                          text: 'Weekly',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'monthly',
                        child: CommonText(
                          text: 'Monthly',
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CommonText(
                            text: currentPeriod == 'monthly'
                                ? 'Monthly'
                                : 'Weekly',
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          SizedBox(width: 4.w),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Custom Line Chart driven by API trend points
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 20, right: 10),
            child: SizedBox(
              height: 160.h,
              child: CustomPaint(
                size: Size.infinite,
                painter: _TrendLineChartPainter(
                  points: trend.points,
                  currentScore: data.currentScore.overall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionComparison(
    List<ProgressDimensionComparisonModel> dimensions,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(
                    text: 'Dimension Comparison',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 4.h),
                  const CommonText(
                    text: 'Pre vs Post Assessment Scores',
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem(const Color(0xFFD48B3B), 'Pre'),
                  SizedBox(width: 12.w),
                  _buildLegendItem(const Color(0xFFFBE1A6), 'Post'),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 10),
            child: SizedBox(
              height: 160.h,
              child: Stack(
                children: [
                  // 1. Dashed grid background with 0..100 Y-axis
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _DimensionBarGridPainter(),
                    ),
                  ),
                  // 2. Bar groups aligned directly to the grid lines
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 130.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: dimensions.map((dim) {
                        return _buildBarPair(
                          preScore: dim.pre,
                          postScore: dim.post,
                          maxHeight: 130.h,
                        );
                      }).toList(),
                    ),
                  ),
                  // 3. Category labels centered below each bar group
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 22.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: dimensions.map((dim) {
                        return Expanded(
                          child: CommonText(
                            text: _formatCategory(dim.category),
                            color: Colors.white54,
                            fontSize: 10,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        CommonText(text: label, color: Colors.white70, fontSize: 12),
      ],
    );
  }

  Widget _buildBarPair({
    int? preScore,
    int? postScore,
    required double maxHeight,
  }) {
    final preFactor =
        preScore != null ? (preScore / 100.0).clamp(0.0, 1.0) : 0.0;
    final postFactor =
        postScore != null ? (postScore / 100.0).clamp(0.0, 1.0) : 0.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Pre Bar (Orange)
        Container(
          width: 14.w,
          height: preScore != null
              ? (maxHeight * preFactor).clamp(3.0, maxHeight)
              : 3.0,
          decoration: BoxDecoration(
            color: preScore != null
                ? const Color(0xFFD48B3B)
                : const Color(0xFFD48B3B).withValues(alpha: 0.25),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(2.5)),
          ),
        ),
        SizedBox(width: 4.w),
        // Post Bar (Cream)
        Container(
          width: 14.w,
          height: postScore != null
              ? (maxHeight * postFactor).clamp(3.0, maxHeight)
              : 3.0,
          decoration: BoxDecoration(
            color: postScore != null
                ? const Color(0xFFFBE1A6)
                : const Color(0xFFFBE1A6).withValues(alpha: 0.25),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(2.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildAiAnalysisCard(String analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFBE1A6),
                size: 20,
              ),
              SizedBox(width: 8.w),
              const CommonText(
                text: 'AI Competency Analysis',
                color: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CommonText(
            text: analysis,
            color: Colors.white70,
            fontSize: 12,
            textAlign: TextAlign.left,
            maxLines: 10,
            lineHeight: 1.5,
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    if (category.isEmpty) return '';
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }
}

void _drawDashedLine(
  Canvas canvas,
  Offset p1,
  Offset p2,
  Paint paint, {
  double dashWidth = 3,
  double dashSpace = 3,
}) {
  final dx = p2.dx - p1.dx;
  final dy = p2.dy - p1.dy;
  final distance = math.sqrt(dx * dx + dy * dy);
  if (distance == 0) return;
  final count = (distance / (dashWidth + dashSpace)).floor();
  final unitX = dx / distance;
  final unitY = dy / distance;

  for (int i = 0; i < count; i++) {
    final startX = p1.dx + (i * (dashWidth + dashSpace)) * unitX;
    final startY = p1.dy + (i * (dashWidth + dashSpace)) * unitY;
    final endX = startX + dashWidth * unitX;
    final endY = startY + dashWidth * unitY;
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }
}

class _TrendLineChartPainter extends CustomPainter {
  final List<ProgressTrendPointModel> points;
  final int currentScore;

  _TrendLineChartPainter({
    required this.points,
    required this.currentScore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartHeight = size.height - 24;

    final paintLine = Paint()
      ..color = const Color(0xFFD48B3B)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final paintDot = Paint()
      ..color = const Color(0xFFD48B3B)
      ..style = PaintingStyle.fill;

    final paintDotInner = Paint()
      ..color = const Color(0xFFFBE1A6)
      ..style = PaintingStyle.fill;

    final paintHalo = Paint()
      ..color = const Color(0xFFD48B3B).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final paintBaseline = Paint()
      ..color = const Color(0xFFD48B3B).withValues(alpha: 0.45)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // 1. Draw horizontal dashed grid lines (0, 25, 50, 75, 100)
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (i * (chartHeight / 4));
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final count = points.length;
    final spacing = count > 1 ? size.width / (count - 1) : size.width;

    // 2. Draw vertical dashed grid lines for each point
    for (int i = 0; i < count; i++) {
      final x = i * spacing;
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, chartHeight), paintGrid);
    }

    // 3. Find scored points from API
    final List<MapEntry<int, Offset>> scoredOffsets = [];

    for (int i = 0; i < count; i++) {
      final score = points[i].overallScore;
      if (score != null) {
        final x = i * spacing;
        final y = chartHeight -
            (score / 100.0 * chartHeight).clamp(0.0, chartHeight);
        scoredOffsets.add(MapEntry(i, Offset(x, y)));
      }
    }

    // 4. Draw curve or baseline
    if (scoredOffsets.length >= 2) {
      final path = Path();
      path.moveTo(scoredOffsets[0].value.dx, scoredOffsets[0].value.dy);

      for (int i = 1; i < scoredOffsets.length; i++) {
        final prev = scoredOffsets[i - 1].value;
        final cur = scoredOffsets[i].value;
        final cx = prev.dx + (cur.dx - prev.dx) / 2;
        path.cubicTo(cx, prev.dy, cx, cur.dy, cur.dx, cur.dy);
      }

      canvas.drawPath(path, paintLine);

      // Draw glowing dots on each scored point
      for (final entry in scoredOffsets) {
        final pt = entry.value;
        canvas.drawCircle(pt, 7.5, paintHalo);
        canvas.drawCircle(pt, 4.0, paintDot);
        canvas.drawCircle(pt, 1.8, paintDotInner);
      }
    } else if (scoredOffsets.length == 1) {
      // 1 scored point (e.g. initial assessment at week 8)
      final scoredEntry = scoredOffsets.first;
      final scoredPt = scoredEntry.value;

      // Draw subtle baseline dashed line leading to the scored point
      _drawDashedLine(
        canvas,
        Offset(0, scoredPt.dy),
        Offset(scoredPt.dx, scoredPt.dy),
        paintBaseline,
      );

      // Faint dots on previous week intersections
      for (int i = 0; i < scoredEntry.key; i++) {
        final x = i * spacing;
        canvas.drawCircle(
          Offset(x, scoredPt.dy),
          2.5,
          Paint()
            ..color = const Color(0xFFD48B3B).withValues(alpha: 0.35)
            ..style = PaintingStyle.fill,
        );
      }

      // Glowing dot on the scored point
      canvas.drawCircle(scoredPt, 7.5, paintHalo);
      canvas.drawCircle(scoredPt, 4.5, paintDot);
      canvas.drawCircle(scoredPt, 2.0, paintDotInner);
    } else if (currentScore > 0) {
      // If points have no scores yet but user has a current overall score
      final baselineY = chartHeight -
          (currentScore / 100.0 * chartHeight).clamp(0.0, chartHeight);
      _drawDashedLine(
        canvas,
        Offset(0, baselineY),
        Offset(size.width, baselineY),
        paintBaseline,
      );
      for (int i = 0; i < count; i++) {
        canvas.drawCircle(
          Offset(i * spacing, baselineY),
          2.5,
          Paint()
            ..color = const Color(0xFFD48B3B).withValues(alpha: 0.3)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // 5. Draw X-axis labels from API points[i].label
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < count; i++) {
      final isScored = points[i].overallScore != null;
      textPainter.text = TextSpan(
        text: points[i].label,
        style: TextStyle(
          color: isScored ? Colors.white : Colors.white54,
          fontSize: 8.5,
          fontWeight: isScored ? FontWeight.w600 : FontWeight.w400,
        ),
      );
      textPainter.layout();
      final x = i * spacing - textPainter.width / 2;
      textPainter.paint(
        canvas,
        Offset(x.clamp(0.0, size.width - textPainter.width), chartHeight + 8),
      );
    }

    // 6. Draw Y-axis labels: 0, 25, 50, 75, 100
    final yLabels = ['0', '25', '50', '75', '100'];
    for (int i = 0; i <= 4; i++) {
      textPainter.text = TextSpan(
        text: yLabels[i],
        style: const TextStyle(color: Colors.white54, fontSize: 9),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width - 8,
          chartHeight - (i * (chartHeight / 4)) - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendLineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.currentScore != currentScore;
  }
}

class _DimensionBarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final chartHeight = 130.0;

    // Draw 5 horizontal dashed grid lines (0, 25, 50, 75, 100)
    for (int i = 0; i <= 4; i++) {
      final y = chartHeight - (i * (chartHeight / 4));
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), paintGrid);
    }

    // Y-axis labels: 0, 25, 50, 75, 100
    final labels = ['0', '25', '50', '75', '100'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i <= 4; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.white54, fontSize: 9),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          -textPainter.width - 8,
          chartHeight - (i * (chartHeight / 4)) - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
