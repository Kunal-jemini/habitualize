import 'package:flutter/material.dart';
import 'package:habitualize/page/homepage/component_homescreen/habit_routine.dart';
import 'package:habitualize/page/homepage/component_homescreen/profile_section.dart';
import 'package:habitualize/page/homepage/component_homescreen/mood_tracker.dart';

class HabitualizeHome extends StatefulWidget {
  const HabitualizeHome({Key? key}) : super(key: key);

  @override
  State<HabitualizeHome> createState() => _HabitualizeHomeState();
}

class _HabitualizeHomeState extends State<HabitualizeHome> {
  final List<String> morningHabits = ["Drink Water", "Stretch", "Meditate"];
  final List<String> workdayHabits = [
    "Plan Tasks",
    "Take Breaks",
    "Check Emails"
  ];
  final List<String> nightHabits = [
    "Read a Book",
    "Reflect on Day",
    "Prepare for Sleep"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade300,
              Colors.orange.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ProfileSection(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      RoutineSection(
                        title: "🌅 Morning Routine",
                        routineType: "Morning",
                        defaultHabits: morningHabits,
                      ),
                      const SizedBox(height: 16),
                      RoutineSection(
                        title: "🏢 Workday Routine",
                        routineType: "Workday",
                        defaultHabits: workdayHabits,
                      ),
                      const SizedBox(height: 16),
                      RoutineSection(
                        title: "🌙 Night Routine",
                        routineType: "Night",
                        defaultHabits: nightHabits,
                      ),
                      const SizedBox(height: 20),
                      const MoodTracker(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
