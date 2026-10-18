import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/features/profile/data/models/legal_content_model.dart';
import 'package:tommy/view/features/profile/domain/repositories/profile_repository.dart';
import 'package:tommy/view/features/profile/domain/usecases/get_legal_content_usecase.dart';
import 'package:tommy/view/features/profile/presentation/bloc/legal_content_cubit.dart';

class StaticContentPage extends StatelessWidget {
  final String title;
  final String slug;

  const StaticContentPage({
    super.key,
    required this.title,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    try {
      context.read<LegalContentCubit>();
      return _StaticContentView(title: title, slug: slug);
    } catch (_) {
      final repo = context.read<ProfileRepository>();
      return BlocProvider(
        create: (_) => LegalContentCubit(
          getLegalContentUseCase: GetLegalContentUseCase(repo),
        )..fetchContent(slug),
        child: _StaticContentView(title: title, slug: slug),
      );
    }
  }
}

class _StaticContentView extends StatelessWidget {
  final String title;
  final String slug;

  const _StaticContentView({
    required this.title,
    required this.slug,
  });

  String _cleanContent(String raw) {
    if (raw.isEmpty) return '';
    var text = raw;
    // Replace <br> and variants with newline
    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    // Replace block end tags with newlines
    text = text.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');
    text = text.replaceAll(RegExp(r'</div>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'</li>', caseSensitive: false), '\n');
    text = text.replaceAll(RegExp(r'<li>', caseSensitive: false), '• ');
    text = text.replaceAll(RegExp(r'</h[1-6]>', caseSensitive: false), '\n\n');
    // Remove all remaining HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');
    // Replace common HTML entities
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&ndash;', '–')
        .replaceAll('&mdash;', '—');
    // Clean up excessive blank lines
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return text.trim();
  }

  String? _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('MMMM d, yyyy').format(dt);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
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
                  Expanded(
                    child: Center(
                      child: CommonText(
                        text: title,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w), // Balance for centering
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<LegalContentCubit, LegalContentState>(
                builder: (context, state) {
                  return switch (state) {
                    LegalContentLoading() || LegalContentInitial() =>
                      const Center(
                        child: CircularProgressIndicator(color: Colors.white70),
                      ),
                    LegalContentError(:final message) => Center(
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
                                    : 'Failed to load content',
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
                                      .read<LegalContentCubit>()
                                      .fetchContent(slug);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    LegalContentLoaded(:final content) =>
                      _buildContentView(context, content),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentView(BuildContext context, LegalContentModel content) {
    final rawText = content.content;
    final parsedText = _cleanContent(rawText);
    final formattedDate = _formatDate(content.updatedAt);

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF2C1E11),
      onRefresh: () => context.read<LegalContentCubit>().fetchContent(slug),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (parsedText.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Colors.white38,
                            size: 44,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No Content Available',
                          style: GoogleFonts.figtree(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'The information for $title will be published soon.',
                          style: GoogleFonts.figtree(
                            color: Colors.white54,
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (formattedDate != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.update,
                          color: Colors.white60,
                          size: 14,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Last updated: $formattedDate',
                          style: GoogleFonts.figtree(
                            color: Colors.white70,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                SelectableText(
                  parsedText,
                  style: GoogleFonts.figtree(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 14.sp,
                    height: 1.65,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
