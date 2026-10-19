import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tommy/core/constant/app_icon.dart';
import 'package:tommy/view/features/ai_coach/data/datasources/ai_coach_socket_service.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_bloc.dart';
import 'package:tommy/view/features/home/presentation/bloc/home_event.dart';
import 'package:tommy/view/features/home/presentation/pages/home_page.dart';
import 'package:tommy/view/features/ai_coach/presentation/pages/ai_coach_page.dart';
import 'package:tommy/view/features/progress/presentation/pages/progress_page.dart';
import 'package:tommy/view/features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  StreamSubscription<AiCoachNotificationData>? _notificationSub;

  final List<Widget> _pages = [
    const HomePage(),
    const AiCoachPage(),
    const ProgressPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    AiCoachSocketService().connect();
    _notificationSub =
        AiCoachSocketService().onNotification.listen((notification) {
      if (notification.title == 'Assessment Reviewed') {
        if (mounted) {
          context.read<HomeBloc>().add(const FetchHomeDataEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color:  Color(0xB7191919), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF140D0B),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFD48B3B),
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navHome),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navHomeActive),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navAi),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navAiActive),
              ),
              label: 'AI Coach',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navProgress),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navProgressActive),
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navProfile),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SvgPicture.asset(AppIcon.navProfileActive),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
