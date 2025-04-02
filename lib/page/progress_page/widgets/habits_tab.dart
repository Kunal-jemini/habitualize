import 'package:flutter/material.dart';
//import 'package:percent_indicator/percent_indicator.dart';
import 'habit_progress_item.dart';

class HabitsTab extends StatelessWidget {
  const HabitsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Performing Habits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        HabitProgressItem(
            title: 'Morning Meditation', progress: 0.95, color: Colors.green),
        const SizedBox(height: 12),
        HabitProgressItem(
            title: 'Reading', progress: 0.8, color: Colors.purple),
        const SizedBox(height: 12),
        HabitProgressItem(title: 'Exercise', progress: 0.75, color: Colors.red),
        const SizedBox(height: 12),
        HabitProgressItem(
            title: 'Drinking Water', progress: 0.7, color: Colors.blue),
        const SizedBox(height: 24),
        const Text(
          'Needs Improvement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        HabitProgressItem(
            title: 'Journaling', progress: 0.4, color: Colors.orange),
        const SizedBox(height: 12),
        HabitProgressItem(
            title: 'Early Sleep', progress: 0.3, color: Colors.indigo),
      ],
    );
  }
}
