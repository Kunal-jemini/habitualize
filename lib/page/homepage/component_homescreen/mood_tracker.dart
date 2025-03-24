import 'package:flutter/material.dart';
import 'package:habitualize/page/journal/mood_tracking_view.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({Key? key}) : super(key: key);

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  int? selectedMoodIndex;
  final List<Map<String, dynamic>> moods = [
    {
      'icon': Icons.sentiment_very_satisfied,
      'label': 'Very Happy',
      'color': Colors.green,
    },
    {
      'icon': Icons.sentiment_satisfied,
      'label': 'Happy',
      'color': Colors.yellow.shade700,
    },
    {
      'icon': Icons.sentiment_neutral,
      'label': 'Neutral',
      'color': Colors.grey.shade600,
    },
    {
      'icon': Icons.sentiment_dissatisfied,
      'label': 'Sad',
      'color': Colors.blue.shade700,
    },
    {
      'icon': Icons.mood_bad,
      'label': 'Angry',
      'color': Colors.red.shade700,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedMoodIndex != null
            ? moods[selectedMoodIndex!]['color'].withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (selectedMoodIndex != null)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MoodTrackingView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('View Stats'),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                return _buildMoodOption(
                  moods[index]['icon'],
                  moods[index]['label'],
                  moods[index]['color'],
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(
    IconData icon,
    String label,
    Color color,
    int index,
  ) {
    final isSelected = selectedMoodIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodIndex = isSelected ? null : index;
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
