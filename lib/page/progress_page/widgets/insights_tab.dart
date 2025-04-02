import 'package:flutter/material.dart';
import 'insight_card.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InsightCard(
          title: 'Great Consistency!',
          content:
              "You've completed your meditation habit 12 days in a row. Keep up the good work!",
          icon: Icons.celebration,
          color: Colors.amber,
        ),
        const SizedBox(height: 16),
        InsightCard(
          title: 'Time to Focus',
          content:
              'Your productivity seems to peak in the morning. Consider scheduling important tasks early in the day.',
          icon: Icons.lightbulb,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        InsightCard(
          title: 'Improvement Needed',
          content:
              "You've been missing your early sleep habit. Try setting a reminder 30 minutes before bedtime.",
          icon: Icons.tips_and_updates,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        InsightCard(
          title: 'New Milestone!',
          content:
              "You've tracked habits for 30 days straight! That's a sign of great dedication.",
          icon: Icons.emoji_events,
          color: Colors.green,
        ),
      ],
    );
  }
}
