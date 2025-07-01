import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class AnimatedProfileReminderBanner extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onCompleteProfile;

  const AnimatedProfileReminderBanner({
    super.key,
    required this.isVisible,
    required this.onCompleteProfile,
  });

  @override
  State<AnimatedProfileReminderBanner> createState() =>
      _AnimatedProfileReminderBannerState();
}

class _AnimatedProfileReminderBannerState
    extends State<AnimatedProfileReminderBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedProfileReminderBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      widget.isVisible ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _controller,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _controller,
        child: SlideTransition(
          position: _slideAnimation,
          child: _ProfileCompletionReminderCard(
            onCompleteProfile: widget.onCompleteProfile,
          ),
        ),
      ),
    );
  }
}




class _ProfileCompletionReminderCard extends StatelessWidget {
  final VoidCallback onCompleteProfile;

  const _ProfileCompletionReminderCard({
    super.key,
    required this.onCompleteProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.amber.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: Colors.orange, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Finish setting up your profile to get the best experience.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onCompleteProfile,
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}
