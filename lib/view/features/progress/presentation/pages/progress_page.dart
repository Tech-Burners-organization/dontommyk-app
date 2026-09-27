import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              const Center(
                child: CommonText(
                  text: 'Your Progress',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30.h),
              const CommonText(
                text: 'Growth Tracker',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 8.h),
              const CommonText(
                text: 'Track your growth across key professional competencies by comparing your assessment results, development progress, and organizational alignment over time.',
                color: Colors.white70,
                fontSize: 14,
                textAlign: TextAlign.left,
                maxLines: 4,
                lineHeight: 1.5,
              ),
              SizedBox(height: 30.h),
              
              // Overall Score Chart Card
              Container(
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
                        const CommonText(text: 'Overall Score', color: Colors.white, fontSize: 16),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CommonText(text: 'Revenue', color: Colors.white54, fontSize: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.trending_up, color: Colors.green, size: 12),
                                    SizedBox(width: 2.w),
                                    const CommonText(text: '4%', color: Colors.green, fontSize: 10),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const CommonText(text: 'Weekly', color: Colors.white70, fontSize: 12),
                                  SizedBox(width: 4.w),
                                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Mock Line Chart
                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 20, right: 10),
                      child: SizedBox(
                        height: 150.h,
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: _LineChartPainter(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // Dimension Comparison Card
              Container(
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
                            const CommonText(text: 'Dimension Comparison', color: Colors.white, fontSize: 16),
                            SizedBox(height: 4.h),
                            const CommonText(text: 'Pre vs Post Assessment Scores', color: Colors.white54, fontSize: 12),
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
                    // Mock Bar Chart
                    SizedBox(
                      height: 150.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBarGroup(0.5, 0.7, 'Behavioral'),
                          _buildBarGroup(0.6, 0.5, 'Emotional'),
                          _buildBarGroup(0.6, 0.65, 'Leadership'),
                          _buildBarGroup(0.6, 0.8, 'Communication'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              
              // AI Competency Analysis Card
              Container(
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
                        const Icon(Icons.auto_awesome, color: Color(0xFFFBE1A6), size: 20),
                        SizedBox(width: 8.w),
                        const CommonText(text: 'AI Competency Analysis', color: Colors.white, fontSize: 16),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const CommonText(
                      text: 'Your focus on emotional regulation is a significant strength. Recent interactions indicate a strong baseline of calm under pressure. However, there are slight fluctuations in your organizational alignment score during high-stakes decision moments. Continuing to leverage your empathy while reinforcing structural boundaries will further solidify your leadership stance.',
                      color: Colors.white70,
                      fontSize: 12,
                      textAlign: TextAlign.left,
                      maxLines: 10,
                      lineHeight: 1.5,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        CommonText(text: label, color: Colors.white70, fontSize: 12),
      ],
    );
  }

  Widget _buildBarGroup(double preFactor, double postFactor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 12.w,
                height: 120.h * preFactor,
                decoration: const BoxDecoration(
                  color: Color(0xFFD48B3B),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                width: 12.w,
                height: 120.h * postFactor,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE1A6),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CommonText(text: label, color: Colors.white54, fontSize: 10),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFFD48B3B)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final paintDot = Paint()
      ..color = const Color(0xFFD48B3B)
      ..style = PaintingStyle.fill;
      
    final paintGrid = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
      
    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      double y = size.height - (i * (size.height / 4));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }
    
    // Draw vertical grid lines (for days)
    for (int i = 0; i < 7; i++) {
      double x = i * (size.width / 6);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    final path = Path();
    
    // Dummy data points mimicking the curve
    final List<Offset> points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 1/6, size.height * 0.7),
      Offset(size.width * 2/6, size.height * 0.45),
      Offset(size.width * 3/6, size.height * 0.5),
      Offset(size.width * 4/6, size.height * 0.3),
      Offset(size.width * 5/6, size.height * 0.15),
      Offset(size.width, size.height * 0.65),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      // Create a smooth curve
      final previousPoint = points[i - 1];
      final currentPoint = points[i];
      final controlPointX = previousPoint.dx + (currentPoint.dx - previousPoint.dx) / 2;
      path.cubicTo(
        controlPointX, previousPoint.dy,
        controlPointX, currentPoint.dy,
        currentPoint.dx, currentPoint.dy,
      );
    }

    canvas.drawPath(path, paintLine);
    
    // Draw dots
    for (var point in points) {
      canvas.drawCircle(point, 4, paintDot);
    }
    
    // Draw text (labels)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < 7; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(i * (size.width / 6) - textPainter.width / 2, size.height + 8));
    }
    
    final values = ['0', '2000', '4000', '6000', '8000'];
    for (int i = 0; i <= 4; i++) {
      textPainter.text = TextSpan(
        text: values[i],
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width - 8, size.height - (i * (size.height / 4)) - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
