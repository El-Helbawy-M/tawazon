import 'package:flutter/material.dart';
import '../../core/entities/session_progress_entity.dart';
import '../../core/entities/session_status.dart';

class SessionCard extends StatelessWidget {
  final SessionProgressEntity session;

  const SessionCard({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = session.sessionName;
    final totalPages = session.totalScreens;
    final finishedPages = session.completedScreens;
    final sessionStatus = SessionStatus.fromValue(session.status);

    final double progress = totalPages > 0
        ? (finishedPages / totalPages).clamp(0.0, 1.0)
        : 0.0;

    Color statusColor;
    IconData statusIcon;

    switch (sessionStatus) {
      case SessionStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case SessionStatus.inProgress:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top;
        break;
      case SessionStatus.notStarted:
        statusColor = Colors.grey;
        statusIcon = Icons.radio_button_unchecked;
        break;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isWide ? 22 : 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Session Progress',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: isWide ? 16 : 14,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              color: statusColor,
              backgroundColor: Colors.grey[300],
              minHeight: isWide ? 10 : 6,
            ),
            const SizedBox(height: 8),
            Text(
              '$finishedPages of $totalPages pages completed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                fontSize: isWide ? 14 : 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(statusIcon, size: isWide ? 22 : 18, color: statusColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    sessionStatus.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                      fontSize: isWide ? 16 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

