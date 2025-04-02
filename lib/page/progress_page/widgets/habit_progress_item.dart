import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HabitProgressItem extends StatelessWidget {
  final String title;
  final double progress;
  final Color color;

  const HabitProgressItem({
    Key? key,
    required this.title,
    required this.progress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getHabitIcon(title),
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: progress,
            backgroundColor: Colors.grey[200],
            progressColor: color,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }

  IconData _getHabitIcon(String habit) {
    switch (habit.toLowerCase()) {
      case 'morning meditation':
        return Icons.self_improvement;
      case 'reading':
        return Icons.menu_book;
      case 'exercise':
        return Icons.fitness_center;
      case 'drinking water':
        return Icons.water_drop;
      case 'journaling':
        return Icons.edit_note;
      case 'early sleep':
        return Icons.bedtime;
      default:
        return Icons.check_circle;
    }
  }
}
