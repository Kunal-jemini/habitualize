import 'package:flutter/material.dart';

class StreakSection extends StatelessWidget {
  final int streakCount;
  final VoidCallback onTap;

  const StreakSection({
    super.key,
    required this.streakCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: Colors.orangeAccent),
              const SizedBox(width: 4),
              Text(
                "$streakCount",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
