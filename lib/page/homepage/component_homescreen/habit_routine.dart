import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RoutineSection extends StatefulWidget {
  final String title;
  final String routineType;
  final List<String> defaultHabits;

  const RoutineSection({
    super.key,
    required this.title,
    required this.routineType,
    required this.defaultHabits,
  });

  @override
  _RoutineSectionState createState() => _RoutineSectionState();
}

class _RoutineSectionState extends State<RoutineSection> {
  Map<String, bool> habitsChecked = {};
  List<String> habits = [];
  TextEditingController habitController = TextEditingController();
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    habits = [...widget.defaultHabits];
    for (var habit in habits) {
      habitsChecked.putIfAbsent(habit, () => false);
    }
  }

  double get completionRate {
    if (habits.isEmpty) return 0.0;
    int completed = habitsChecked.values.where((checked) => checked).length;
    return completed / habits.length;
  }

  void addHabit() {
    if (habitController.text.isNotEmpty) {
      setState(() {
        habits.add(habitController.text);
        habitsChecked[habitController.text] = false;
        habitController.clear();
      });
    }
  }

  void removeHabit(String habit) {
    setState(() {
      habits.remove(habit);
      habitsChecked.remove(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getRoutineColor().withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    _getRoutineColor().withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  // Icon based on routine type with animated container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getRoutineColor().withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getRoutineColor().withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getRoutineIcon(),
                      color: _getRoutineColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (habits.isNotEmpty)
                              Text(
                                "${habitsChecked.values.where((checked) => checked).length}/${habits.length}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              height: 6,
                              width: MediaQuery.of(context).size.width *
                                  0.6 *
                                  completionRate,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getRoutineColor().withOpacity(0.7),
                                    _getRoutineColor(),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRoutineColor().withOpacity(0.3),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Progress Circle
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: CircularPercentIndicator(
                      radius: 20.0,
                      lineWidth: 4.0,
                      animation: true,
                      animationDuration: 500,
                      percent: completionRate,
                      center: Text(
                        "${(completionRate * 100).toInt()}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: _getRoutineColor(),
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: _getRoutineColor(),
                      backgroundColor: Colors.grey[200]!,
                    ),
                  ),
                  // Expand/Collapse Icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: _getRoutineColor(),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded Content with Animation
          AnimatedCrossFade(
            firstChild: const SizedBox(height: 0),
            secondChild: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Add New Habit
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: habitController,
                            decoration: InputDecoration(
                              hintText: "Add a new habit",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(Icons.add_circle_outline,
                                  color: _getRoutineColor()),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: addHabit,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: _getRoutineColor(),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Habits List
                  ...habits.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String habit = entry.value;
                    final bool isChecked = habitsChecked[habit] ?? false;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isChecked
                            ? _getRoutineColor().withOpacity(0.05)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isChecked
                              ? _getRoutineColor().withOpacity(0.2)
                              : Colors.grey[200]!,
                          width: 1,
                        ),
                        boxShadow: isChecked
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: InkWell(
                          onTap: () {
                            setState(() {
                              habitsChecked[habit] = !isChecked;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color:
                                  isChecked ? _getRoutineColor() : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isChecked
                                    ? _getRoutineColor()
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: isChecked
                                ? const Icon(
                                    Icons.check,
                                    size: 18.0,
                                    color: Colors.white,
                                  )
                                : const SizedBox(
                                    width: 18,
                                    height: 18,
                                  ),
                          ),
                        ),
                        title: Text(
                          habit,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                isChecked ? FontWeight.normal : FontWeight.w500,
                            decoration: isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color:
                                isChecked ? Colors.grey[400] : Colors.black87,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete button
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[300],
                              ),
                              onPressed: () => removeHabit(habit),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Color _getRoutineColor() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return Colors.orange;
      case 'workday':
        return Colors.blue;
      case 'night':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoutineIcon() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return Icons.wb_sunny;
      case 'workday':
        return Icons.work;
      case 'night':
        return Icons.nightlight;
      default:
        return Icons.check_circle;
    }
  }
}
