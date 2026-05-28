import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/notification_model.dart';

const _tabRoutes = {
  Routes.home,
  Routes.questions,
  Routes.competitions,
  Routes.vocabulary,
  Routes.profile,
};

List<NotifModel> _buildNotifications() => [
      NotifModel(
        icon: PhosphorIconsFill.trophy,
        color: AppColors.warning,
        title: 'New competition started!',
        body: 'SAT Winter Challenge 2025 is now open. Register to compete.',
        time: '2 min ago',
        route: Routes.competitions,
      ),
      NotifModel(
        icon: PhosphorIconsFill.checkCircle,
        color: AppColors.success,
        title: 'Daily goal reached 🎉',
        body: 'You completed 20 questions today. Keep up the streak!',
        time: '1 h ago',
        // no route → shows detail sheet
      ),
      NotifModel(
        icon: PhosphorIconsFill.lightning,
        color: AppColors.primary,
        title: 'Question Rush available',
        body: 'New batch of questions added. Challenge yourself now.',
        time: '3 h ago',
        isRead: true,
        route: Routes.questionRush,
      ),
      NotifModel(
        icon: PhosphorIconsFill.bookOpen,
        color: AppColors.secondary,
        title: 'Vocabulary reminder',
        body: "You haven't practiced vocabulary today. 5 min is all it takes.",
        time: 'Yesterday',
        isRead: true,
        route: Routes.vocabulary,
      ),
      NotifModel(
        icon: PhosphorIconsFill.path,
        color: AppColors.success,
        title: 'Roadmap update',
        body: "You're 60% through your learning path. Keep going!",
        time: '2 days ago',
        isRead: true,
        route: Routes.roadmap,
      ),
      NotifModel(
        icon: PhosphorIconsFill.headset,
        color: AppColors.warning,
        title: 'Session reminder',
        body: 'Your live support session with a mentor is tomorrow at 15:00.',
        time: '2 days ago',
        isRead: true,
        route: Routes.support,
      ),
      NotifModel(
        icon: PhosphorIconsFill.star,
        color: AppColors.gold,
        title: 'New achievement unlocked',
        body: 'You earned "First 100 Questions" badge. View your profile.',
        time: '3 days ago',
        isRead: true,
        route: Routes.profile,
      ),
    ];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final List<NotifModel> _notifs = _buildNotifications();

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() => setState(() {
        for (final n in _notifs) {
          n.isRead = true;
        }
      });

  void _onTap(int index) {
    final notif = _notifs[index];

    // Mark as read
    if (!notif.isRead) setState(() => notif.isRead = true);

    final route = notif.route;
    if (route == null) {
      _showDetail(notif);
    } else if (_tabRoutes.contains(route)) {
      context.go(route);
    } else {
      context.push(route);
    }
  }

  void _showDetail(NotifModel notif) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _NotifDetailSheet(notif: notif),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = _unreadCount;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifs.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    '${_notifs.length} notifications',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (unread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$unread new',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          final i = index - 1;
          return _NotifCard(
            notif: _notifs[i],
            onTap: () => _onTap(i),
          );
        },
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotifModel notif;
  final VoidCallback onTap;

  const _NotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.bgPrimary : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notif.isRead ? AppColors.borderLight : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notif.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(notif.icon, color: notif.color, size: 20),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        notif.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (notif.route != null) ...[
                        const Spacer(),
                        const Text(
                          'View →',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifDetailSheet extends StatelessWidget {
  final NotifModel notif;

  const _NotifDetailSheet({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: const BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: notif.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(notif.icon, color: notif.color, size: 30),
            ),
            const SizedBox(height: 16),

            // Title & body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Text(
                    notif.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notif.body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
