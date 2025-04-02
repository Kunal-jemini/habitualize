import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineDetailPage extends StatefulWidget {
  final String routineType;
  final List<String> habits;

  const RoutineDetailPage({
    Key? key,
    required this.routineType,
    required this.habits,
  }) : super(key: key);

  @override
  State<RoutineDetailPage> createState() => _RoutineDetailPageState();
}

class _RoutineDetailPageState extends State<RoutineDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<bool> _completedHabits = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();

    // Initialize completion status for each habit
    _completedHabits.addAll(List.generate(widget.habits.length, (_) => false));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getGradientForRoutineType(widget.routineType),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        '${widget.routineType} Routine',
                        style: GoogleFonts.workSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for back button
                  ],
                ),
              ),

              // Inspirational message
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text(
                  _getInspirationMessage(widget.routineType),
                  style: GoogleFonts.workSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Habits list
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: ListView.builder(
                    itemCount: widget.habits.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final delay = index * 0.2;
                          final startValue = delay;
                          final endValue = delay + 0.8;
                          final animationValue = _animationController.value;

                          final opacity = animationValue < startValue
                              ? 0.0
                              : animationValue > endValue
                                  ? 1.0
                                  : (animationValue - startValue) /
                                      (endValue - startValue);

                          final slideValue = animationValue < startValue
                              ? 50.0
                              : animationValue > endValue
                                  ? 0.0
                                  : 50.0 -
                                      (50.0 *
                                          (animationValue - startValue) /
                                          (endValue - startValue));

                          return Opacity(
                            opacity: opacity,
                            child: Transform.translate(
                              offset: Offset(0, slideValue),
                              child: _buildHabitCard(index),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            setState(() {
              _completedHabits[index] = !_completedHabits[index];
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Completion indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _completedHabits[index]
                        ? _getColorForRoutineType(widget.routineType)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getColorForRoutineType(widget.routineType),
                      width: 2,
                    ),
                  ),
                  child: _completedHabits[index]
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Habit text
                Expanded(
                  child: Text(
                    widget.habits[index],
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: _completedHabits[index]
                          ? TextDecoration.lineThrough
                          : null,
                      color: _completedHabits[index]
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
                // Time estimate icon
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),
                Text(
                  '${5 + index * 2} min',
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForRoutineType(String type) {
    switch (type) {
      case 'Morning':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        );
      case 'Daily':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
        );
      case 'Evening':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5E35B1), Color(0xFF3949AB)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
        );
    }
  }

  Color _getColorForRoutineType(String type) {
    switch (type) {
      case 'Morning':
        return const Color(0xFFFF7043);
      case 'Daily':
        return const Color(0xFF00ACC1);
      case 'Evening':
        return const Color(0xFF3949AB);
      default:
        return const Color(0xFF673AB7);
    }
  }

  String _getInspirationMessage(String type) {
    switch (type) {
      case 'Morning':
        return 'Start your day with intention and energy';
      case 'Daily':
        return 'Small actions lead to big transformations';
      case 'Evening':
        return 'Wind down and reflect on your accomplishments';
      default:
        return 'Build your perfect routine one habit at a time';
    }
  }
}
