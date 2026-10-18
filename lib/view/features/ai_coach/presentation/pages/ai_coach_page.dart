import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tommy/view/component/background/app_background.dart';
import 'package:tommy/view/component/common_button/common_button.dart';
import 'package:tommy/view/component/common_text/common_text.dart';
import 'package:tommy/view/component/custom_text_field/custom_text_field.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_conversation_model.dart';
import 'package:tommy/view/features/ai_coach/data/models/ai_message_model.dart';
import 'package:tommy/view/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/create_ai_conversation_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_conversations_usecase.dart';
import 'package:tommy/view/features/ai_coach/domain/usecases/get_ai_messages_usecase.dart';
import 'package:tommy/view/features/ai_coach/presentation/bloc/ai_conversations_cubit.dart';

class AiCoachPage extends StatelessWidget {
  const AiCoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AiCoachRepository>();
    return BlocProvider(
      create: (context) => AiConversationsCubit(
        getAiConversationsUseCase: GetAiConversationsUseCase(repo),
        createAiConversationUseCase: CreateAiConversationUseCase(repo),
        getAiMessagesUseCase: GetAiMessagesUseCase(repo),
      )..fetchConversations(),
      child: const _AiCoachPageView(),
    );
  }
}

class _AiCoachPageView extends StatefulWidget {
  const _AiCoachPageView();

  @override
  State<_AiCoachPageView> createState() => _AiCoachPageViewState();
}

class _AiCoachPageViewState extends State<_AiCoachPageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AiConversationsCubit>().fetchConversations();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildConversationDrawer(context),
      body: AppBackground(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlocBuilder<AiConversationsCubit,
                        AiConversationsState>(
                      builder: (context, state) {
                        final title = switch (state) {
                          AiConversationsLoaded(
                            :final activeConversation
                          ) =>
                            activeConversation?.title ?? 'AI Coach',
                          _ => 'AI Coach',
                        };

                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFD48B3B)
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                  color: const Color(0xFFD48B3B)
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFD48B3B),
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.figtree(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Personalized Alignment Guidance',
                                    style: GoogleFonts.figtree(
                                      color: Colors.white54,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38),
                    ),
                    child: IconButton(
                      tooltip: 'Conversations history',
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        context
                            .read<AiConversationsCubit>()
                            .fetchConversations();
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocConsumer<AiConversationsCubit, AiConversationsState>(
                listener: (context, state) {
                  if (state is AiConversationsLoaded && !state.isLoadingMessages) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  }
                },
                builder: (context, state) {
                  return ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    children: [
                      _buildAiBubble(
                        'Hi! I\'m your AlignIQ AI Coach. I\'ve analyzed your assessment results and I\'m here to give you personalized guidance. What would you like to work on today?',
                      ),
                      if (state is AiConversationsLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD48B3B),
                              strokeWidth: 2.5,
                            ),
                          ),
                        )
                      else if (state is AiConversationsLoaded) ...[
                        if (state.isLoadingMessages)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFD48B3B),
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        else if (state.messagesError != null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Column(
                              children: [
                                Text(
                                  'Failed to load messages: ${state.messagesError}',
                                  style: GoogleFonts.figtree(
                                    color: Colors.redAccent,
                                    fontSize: 13.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Color(0xFFD48B3B),
                                    size: 16,
                                  ),
                                  label: Text(
                                    'Retry',
                                    style: GoogleFonts.figtree(
                                      color: const Color(0xFFD48B3B),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (state.activeConversationId != null) {
                                      context
                                          .read<AiConversationsCubit>()
                                          .fetchMessages(
                                              state.activeConversationId!);
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        else if (state.messages.isNotEmpty)
                          ...state.messages.map((msg) {
                            if (msg.isUser) {
                              return _buildUserBubble(
                                msg.content,
                                time: msg.formattedTime,
                              );
                            } else {
                              return _buildAiBubble(
                                msg.content,
                                time: msg.formattedTime,
                              );
                            }
                          })
                        else if (state.activeConversation != null) ...[
                          _buildUserBubble(state.activeConversation!.title),
                          _buildAiBubble(
                            'I understand you\'re experiencing this: "${state.activeConversation!.title}". Let\'s break this down into actionable steps. What triggered this feeling recently?',
                          ),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),

            // Bottom Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<AiConversationsCubit, AiConversationsState>(
                    builder: (context, state) {
                      final items = (state is AiConversationsLoaded &&
                              state.conversations.isNotEmpty)
                          ? state.conversations
                          : <AiConversationModel>[];

                      final chips = items.isNotEmpty
                          ? items.map((c) => c.title).take(5).toList()
                          : [
                              'I feel stressed',
                              'Conflict prep',
                              'Score meaning',
                            ];

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: chips.map((chipText) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  _textController.text = chipText;
                                  if (items.isNotEmpty) {
                                    try {
                                      final matched = items.firstWhere(
                                        (c) =>
                                            c.title.trim().toLowerCase() ==
                                            chipText.trim().toLowerCase(),
                                      );
                                      context
                                          .read<AiConversationsCubit>()
                                          .selectConversation(matched.id);
                                      return;
                                    } catch (_) {}
                                  }
                                  await context
                                      .read<AiConversationsCubit>()
                                      .createConversation(chipText);
                                },
                                child: _buildChip(chipText),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 14.h),
                  CustomTextField(
                    controller: _textController,
                    hintText: 'Type your question...',
                    fillColor: Colors.black.withValues(alpha: 0.5),
                    fieldBorderColor: Colors.white38,
                    fieldBorderRadius: 24,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        _showCreateConversationDialog(context);
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_outlined, color: Colors.white),
                      onPressed: () async {
                        final text = _textController.text.trim();
                        if (text.isNotEmpty) {
                          _textController.clear();
                          final cubit = context.read<AiConversationsCubit>();
                          final state = cubit.state;
                          if (state is! AiConversationsLoaded ||
                              state.activeConversation == null) {
                            await cubit.createConversation(text);
                          }
                        }
                      },
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white70),
                    cursorColor: Colors.white,
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF191210),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      'Conversations',
                      style: GoogleFonts.figtree(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: BlocBuilder<AiConversationsCubit, AiConversationsState>(
                builder: (context, state) {
                  final isCreating =
                      state is AiConversationsLoaded && state.isCreating;
                  return CommonButton(
                    titleText:
                        isCreating ? 'Creating...' : '+ New Conversation',
                    titleColor: Colors.black,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC77926), Color(0xFFFBE1A6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    onTap: isCreating
                        ? null
                        : () {
                            _showCreateConversationDialog(context);
                          },
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: BlocBuilder<AiConversationsCubit, AiConversationsState>(
                builder: (context, state) {
                  if (state is AiConversationsInitial) {
                    context.read<AiConversationsCubit>().fetchConversations();
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD48B3B),
                      ),
                    );
                  }

                  if (state is AiConversationsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD48B3B),
                      ),
                    );
                  }

                  if (state is AiConversationsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 36,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              state.message.isNotEmpty
                                  ? state.message
                                  : 'Failed to load conversations',
                              style: GoogleFonts.figtree(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 14.h),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white38),
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Try Again'),
                              onPressed: () {
                                context
                                    .read<AiConversationsCubit>()
                                    .fetchConversations();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is AiConversationsLoaded) {
                    return _buildDrawerConversationList(
                      context,
                      state.conversations,
                      state.activeConversationId,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerConversationList(
    BuildContext context,
    List<AiConversationModel> conversations,
    String? activeId,
  ) {
    if (conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white30,
                size: 40,
              ),
              SizedBox(height: 12.h),
              Text(
                'No conversations yet',
                style: GoogleFonts.figtree(
                  color: Colors.white70,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Start a new chat to begin coaching.',
                style: GoogleFonts.figtree(
                  color: Colors.white38,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF2C1E11),
      onRefresh: () =>
          context.read<AiConversationsCubit>().fetchConversations(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final item = conversations[index];
          final isActive = item.id == activeId;

          return GestureDetector(
            onTap: () {
              context.read<AiConversationsCubit>().selectConversation(item.id);
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFD48B3B).withValues(alpha: 0.12)
                    : const Color(0xFF161111),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFFD48B3B)
                      : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_outlined,
                    color: isActive
                        ? const Color(0xFFD48B3B)
                        : Colors.white54,
                    size: 18,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.figtree(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _formatDate(item.lastMessageAt ?? item.createdAt),
                          style: GoogleFonts.figtree(
                            color: Colors.white38,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD48B3B),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiBubble(String text, {String? time}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF261911),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD48B3B).withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFD48B3B),
                  size: 14,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'AI Coach',
                style: GoogleFonts.figtree(
                  color: const Color(0xFFD48B3B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (time != null && time.isNotEmpty) ...[
                SizedBox(width: 8.w),
                Text(
                  time,
                  style: GoogleFonts.figtree(
                    color: Colors.white38,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10.h),
          SelectableText(
            text,
            style: GoogleFonts.figtree(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 14.sp,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(String text, {String? time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFF161111),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(4.r),
          ),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SelectableText(
              text,
              style: GoogleFonts.figtree(
                color: Colors.white,
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
            if (time != null && time.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                time,
                style: GoogleFonts.figtree(
                  color: Colors.white38,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: CommonText(
        text: text,
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }

  void _showCreateConversationDialog(BuildContext context) {
    final titleController = TextEditingController(text: 'I feel stressed');
    final cubit = context.read<AiConversationsCubit>();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E140F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: const Color(0xFFD48B3B).withValues(alpha: 0.4),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD48B3B).withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFFD48B3B),
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'New Conversation',
                    style: GoogleFonts.figtree(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested topics:',
                    style: GoogleFonts.figtree(
                      color: Colors.white60,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'I feel stressed',
                      'Conflict prep',
                      'Score meaning',
                      'Leadership growth',
                    ].map((topic) {
                      final isSelected = titleController.text.trim() == topic;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            titleController.text = topic;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFD48B3B).withValues(alpha: 0.25)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD48B3B)
                                  : Colors.white24,
                            ),
                          ),
                          child: Text(
                            topic,
                            style: GoogleFonts.figtree(
                              color: Colors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Enter conversation title...',
                    fillColor: Colors.black.withValues(alpha: 0.5),
                    fieldBorderColor:
                        const Color(0xFFD48B3B).withValues(alpha: 0.5),
                    fieldBorderRadius: 14,
                    textStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white38),
                  ),
                ],
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                TextButton(
                  onPressed:
                      isSubmitting ? null : () => Navigator.pop(dialogCtx),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.figtree(color: Colors.white60),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD48B3B),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final title = titleController.text.trim();
                          if (title.isEmpty) return;

                          setDialogState(() => isSubmitting = true);
                          final created =
                              await cubit.createConversation(title);

                          if (dialogCtx.mounted) {
                            Navigator.pop(dialogCtx);
                          }

                          if (created != null) {
                            if (_scaffoldKey.currentState?.isEndDrawerOpen ??
                                false) {
                              Navigator.pop(context);
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to create conversation. Please try again.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          'Create',
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
