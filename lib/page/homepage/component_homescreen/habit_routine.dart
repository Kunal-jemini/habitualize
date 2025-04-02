import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;

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

class _RoutineSectionState extends State<RoutineSection>
    with SingleTickerProviderStateMixin {
  Map<String, bool> habitsChecked = {};
  List<String> habits = [];
  TextEditingController habitController = TextEditingController();
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isLoading = false;
  bool _isAddingHabit = false;

  // Habit icons mapping
  final Map<String, IconData> _habitIcons = {
    'drink water': Icons.water_drop,
    'meditate': Icons.self_improvement,
    'exercise': Icons.fitness_center,
    'read': Icons.book,
    'journal': Icons.edit_note,
    'sleep early': Icons.bedtime,
    'eat breakfast': Icons.restaurant,
    'take vitamins': Icons.medication,
    'stretch': Icons.accessibility_new,
    'walk': Icons.directions_walk,
  };

  @override
  void initState() {
    super.initState();
    habits = [...widget.defaultHabits];
    for (var habit in habits) {
      habitsChecked.putIfAbsent(habit, () => false);
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.03).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    habitController.dispose();
    super.dispose();
  }

  double get completionRate {
    if (habits.isEmpty) return 0.0;
    int completed = habitsChecked.values.where((checked) => checked).length;
    return completed / habits.length;
  }

  Future<void> addHabit() async {
    if (habitController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        habits.add(habitController.text);
        habitsChecked[habitController.text] = false;
        habitController.clear();
        _isLoading = false;
        _isAddingHabit = false;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Habit added to your ${widget.routineType} routine',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: _getRoutineColor(),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> toggleHabit(String habit) async {
    HapticFeedback.lightImpact();
    setState(() {
      habitsChecked[habit] = !habitsChecked[habit]!;
    });

    if (habitsChecked[habit]!) {
      // Show a success message when habit is checked
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.celebration,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Great job completing "${habit}"!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: _getRoutineColor(),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void removeHabit(String habit) {
    setState(() {
      habits.remove(habit);
      habitsChecked.remove(habit);
    });
  }

  Color _getRoutineColor() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return const Color(0xFFFF9D76); // Fabulous orange
      case 'evening':
        return const Color(0xFF8C82FC); // Fabulous purple
      case 'daily':
        return const Color(0xFF26C6DA); // Fabulous teal
      default:
        return const Color(0xFF607D8B);
    }
  }

  Color _getSecondaryColor() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return const Color(0xFFFFB74D); // Lighter orange
      case 'evening':
        return const Color(0xFFB39DDB); // Lighter purple
      case 'daily':
        return const Color(0xFF80DEEA); // Lighter teal
      default:
        return const Color(0xFFB0BEC5);
    }
  }

  LinearGradient _getGradient() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return LinearGradient(
          colors: [
            const Color(0xFFFF9D76),
            const Color(0xFFFF7A50),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'evening':
        return LinearGradient(
          colors: [
            const Color(0xFF8C82FC),
            const Color(0xFF6A5AE0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'daily':
        return LinearGradient(
          colors: [
            const Color(0xFF26C6DA),
            const Color(0xFF00ACC1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF607D8B),
            const Color(0xFF455A64),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getRoutineIcon() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return Icons.wb_sunny_rounded;
      case 'evening':
        return Icons.nights_stay_rounded;
      case 'daily':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _getRoutineImage() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return 'assets/images/morning.png';
      case 'evening':
        return 'assets/images/evening.png';
      case 'daily':
        return 'assets/images/daily.png';
      default:
        return 'assets/images/default.png';
    }
  }

  String _getMotivationalText() {
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return 'Start your day with intention';
      case 'evening':
        return 'Wind down and reflect';
      case 'daily':
        return 'Build consistency every day';
      default:
        return 'Stay consistent with your habits';
    }
  }

  IconData _getHabitIcon(String habit) {
    final lowerHabit = habit.toLowerCase();

    // Check if we have a predefined icon for this habit
    for (final entry in _habitIcons.entries) {
      if (lowerHabit.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default icons based on routine type
    switch (widget.routineType.toLowerCase()) {
      case 'morning':
        return Icons.emoji_objects_rounded;
      case 'evening':
        return Icons.nightlight_round;
      case 'daily':
        return Icons.star_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isLargeScreen = screenSize.width > 600;

    // Dynamic scaling factors based on screen size
    final double scaleFactor =
        isSmallScreen ? 0.8 : (isLargeScreen ? 1.0 : 0.9);
    final double iconSize =
        isSmallScreen ? 16.0 : (isLargeScreen ? 22.0 : 20.0);
    final double padding = isSmallScreen ? 8.0 : (isLargeScreen ? 14.0 : 12.0);

    // Dynamic spacing calculations
    final double sectionSpacing =
        screenSize.height * (isSmallScreen ? 0.008 : 0.012);
    final double bottomPadding =
        screenSize.height * (isSmallScreen ? 0.015 : 0.02);
    final double verticalMargin =
        screenSize.height * (isSmallScreen ? 0.004 : 0.006);
    final double borderRadius = 16.0 * scaleFactor;
    final double progressBarHeight = 4.0 * scaleFactor;
    final double progressCircleRadius =
        isSmallScreen ? 16.0 : (isLargeScreen ? 20.0 : 18.0);
    final double progressCircleLineWidth =
        isSmallScreen ? 2.0 : (isLargeScreen ? 3.0 : 2.5);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: verticalMargin, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: _getRoutineColor().withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 12 * scaleFactor,
              offset: Offset(0, 3 * scaleFactor),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            GestureDetector(
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) {
                _animationController.reverse();
                setState(() {
                  isExpanded = !isExpanded;
                });
                HapticFeedback.mediumImpact();
              },
              onTapCancel: () => _animationController.reverse(),
              child: Container(
                padding: EdgeInsets.only(
                  top: padding,
                  bottom: padding,
                  left: padding,
                  right: padding * 0.875,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      _getRoutineColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Icon with enhanced animation
                        Container(
                          padding: EdgeInsets.all(
                              isSmallScreen ? 6 : (isLargeScreen ? 10 : 8)),
                          decoration: BoxDecoration(
                            gradient: _getGradient(),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getRoutineColor().withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 6 * scaleFactor,
                                offset: Offset(0, 2 * scaleFactor),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getRoutineIcon(),
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(
                            width:
                                isSmallScreen ? 8 : (isLargeScreen ? 12 : 10)),

                        // Title and Progress
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontSize: isSmallScreen
                                            ? 13
                                            : (isLargeScreen ? 17 : 15),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                      width: isSmallScreen
                                          ? 4
                                          : (isLargeScreen ? 8 : 6)),
                                  if (habits.isNotEmpty)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen
                                            ? 4
                                            : (isLargeScreen ? 6 : 5),
                                        vertical: isSmallScreen
                                            ? 1
                                            : (isLargeScreen ? 3 : 2),
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRoutineColor()
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(
                                            10 * scaleFactor),
                                      ),
                                      child: Text(
                                        "${habitsChecked.values.where((checked) => checked).length}/${habits.length}",
                                        style: TextStyle(
                                          fontSize: isSmallScreen
                                              ? 9
                                              : (isLargeScreen ? 13 : 11),
                                          color: _getRoutineColor(),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getMotivationalText(),
                                style: TextStyle(
                                  fontSize: isSmallScreen
                                      ? 9
                                      : (isLargeScreen ? 13 : 11),
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 6),
                              Stack(
                                children: [
                                  // Progress background
                                  Container(
                                    height: progressBarHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                          progressBarHeight / 2),
                                    ),
                                  ),
                                  // Progress fill with responsive width
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.easeOutQuart,
                                    height: progressBarHeight,
                                    width: ((MediaQuery.of(context).size.width -
                                                (padding * 2) -
                                                (isSmallScreen
                                                    ? 90
                                                    : (isLargeScreen
                                                        ? 130
                                                        : 110))) *
                                            completionRate)
                                        .clamp(0.0, double.infinity),
                                    decoration: BoxDecoration(
                                      gradient: _getGradient(),
                                      borderRadius: BorderRadius.circular(
                                          progressBarHeight / 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getRoutineColor()
                                              .withOpacity(0.3),
                                          blurRadius: 1 * scaleFactor,
                                          offset: Offset(0, 1 * scaleFactor),
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
                          margin: EdgeInsets.only(left: 4 * scaleFactor),
                          child: CircularPercentIndicator(
                            radius: progressCircleRadius,
                            lineWidth: progressCircleLineWidth,
                            animation: true,
                            animationDuration: 1000,
                            percent: completionRate,
                            center: Text(
                              "${(completionRate * 100).toInt()}%",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: isSmallScreen
                                    ? 7.0
                                    : (isLargeScreen ? 11.0 : 9.0),
                                color: _getRoutineColor(),
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: _getRoutineColor(),
                            backgroundColor: Colors.grey[100]!,
                            backgroundWidth: isSmallScreen
                                ? 0.8
                                : (isLargeScreen ? 1.5 : 1.2),
                          ),
                        ),
                      ],
                    ),

                    // Tag pill
                    AnimatedOpacity(
                      opacity: isExpanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isExpanded ? (isSmallScreen ? 24 : 28) : 0,
                        margin: EdgeInsets.only(
                            top: isExpanded ? (isSmallScreen ? 6 : 8) : 0),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 10,
                          vertical: isSmallScreen ? 4 : 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: _getGradient(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getRoutineIcon(),
                              color: Colors.white,
                              size: isSmallScreen ? 10 : 12,
                            ),
                            SizedBox(width: isSmallScreen ? 3 : 4),
                            Text(
                              widget.routineType,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: isSmallScreen ? 9 : 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Content
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Motivational header section
                    Container(
                      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                      decoration: BoxDecoration(
                        color: _getRoutineColor().withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getRoutineColor().withOpacity(0.12),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 5 : 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getRoutineColor().withOpacity(0.15),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: _getRoutineColor(),
                              size: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  completionRate == 1.0
                                      ? "Amazing job! 🎉"
                                      : "Keep up the good work!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: isSmallScreen ? 11 : 13,
                                    color: _getRoutineColor(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  completionRate == 1.0
                                      ? "You've completed all your habits today!"
                                      : "You're building great habits for your ${widget.routineType.toLowerCase()} routine",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: isSmallScreen ? 9 : 11,
                                    height: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Add Habit Section
                    AnimatedCrossFade(
                      firstChild: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isAddingHabit = true;
                            });
                            HapticFeedback.lightImpact();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 6 : 8),
                            decoration: BoxDecoration(
                              color: _getRoutineColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getRoutineColor().withOpacity(0.2),
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: _getRoutineColor(),
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Text(
                                    "Add New Habit",
                                    style: TextStyle(
                                      color: _getRoutineColor(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmallScreen ? 11 : 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondChild: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          border: Border.all(
                            color: _getRoutineColor().withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: habitController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter a new habit...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: isSmallScreen ? 10 : 11,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 8 : 12,
                                        vertical: isSmallScreen ? 8 : 10,
                                      ),
                                    ),
                                    onSubmitted: (_) => addHabit(),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: addHabit,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(12)),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          isSmallScreen ? 8 : 10),
                                      child: _isLoading
                                          ? SizedBox(
                                              width: isSmallScreen ? 14 : 16,
                                              height: isSmallScreen ? 14 : 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        _getRoutineColor()),
                                              ),
                                            )
                                          : Icon(
                                              Icons.add_circle,
                                              color: _getRoutineColor(),
                                              size: isSmallScreen ? 16 : 18,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 1, color: Colors.grey[200]),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isAddingHabit = false;
                                        habitController.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey[600],
                                      size: isSmallScreen ? 10 : 12,
                                    ),
                                    label: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: isSmallScreen ? 9 : 11,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: addHabit,
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: _getRoutineColor(),
                                      size: isSmallScreen ? 10 : 12,
                                    ),
                                    label: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: _getRoutineColor(),
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallScreen ? 9 : 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      crossFadeState: _isAddingHabit
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),

                    SizedBox(height: isSmallScreen ? 8 : 10),

                    // Habits List
                    ...habits.asMap().entries.map((entry) {
                      final index = entry.key;
                      final habit = entry.value;
                      final isChecked = habitsChecked[habit] ?? false;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: isSmallScreen ? 4 : 6),
                        decoration: BoxDecoration(
                          color: isChecked
                              ? _getRoutineColor().withOpacity(0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(isChecked ? 0.03 : 0.06),
                              spreadRadius: 0,
                              blurRadius: isChecked ? 1 : 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          border: Border.all(
                            color: isChecked
                                ? _getRoutineColor().withOpacity(0.25)
                                : Colors.grey.withOpacity(0.1),
                            width: 1.0,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => toggleHabit(habit),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 8 : 10,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            child: Row(
                              children: [
                                // Checkbox
                                InkWell(
                                  onTap: () => toggleHabit(habit),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: isSmallScreen ? 16 : 18,
                                    height: isSmallScreen ? 16 : 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isChecked
                                          ? _getRoutineColor()
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isChecked
                                            ? _getRoutineColor()
                                            : Colors.grey[300]!,
                                        width: 1.2,
                                      ),
                                      boxShadow: isChecked
                                          ? [
                                              BoxShadow(
                                                color: _getRoutineColor()
                                                    .withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: isChecked
                                        ? Icon(
                                            Icons.check,
                                            size: isSmallScreen ? 10 : 12,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),

                                SizedBox(width: isSmallScreen ? 6 : 8),

                                // Habit Icon
                                Container(
                                  padding:
                                      EdgeInsets.all(isSmallScreen ? 4 : 5),
                                  decoration: BoxDecoration(
                                    color: isChecked
                                        ? _getRoutineColor().withOpacity(0.12)
                                        : _getSecondaryColor()
                                            .withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getHabitIcon(habit),
                                    color: isChecked
                                        ? _getRoutineColor()
                                        : _getSecondaryColor(),
                                    size: isSmallScreen ? 12 : 14,
                                  ),
                                ),

                                SizedBox(width: isSmallScreen ? 6 : 8),

                                // Habit Name
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        habit,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 11 : 12,
                                          fontWeight: isChecked
                                              ? FontWeight.w500
                                              : FontWeight.w600,
                                          decoration: isChecked
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isChecked
                                              ? Colors.grey[500]
                                              : Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      if (!isChecked)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1),
                                          child: Text(
                                            "Tap to complete",
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 8 : 9,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // Delete button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => removeHabit(habit),
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(isSmallScreen ? 2 : 3),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.grey[400],
                                        size: isSmallScreen ? 14 : 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    // Empty state
                    if (habits.isEmpty)
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        margin: EdgeInsets.only(top: isSmallScreen ? 4 : 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.list_alt_rounded,
                                size: isSmallScreen ? 20 : 24,
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 6 : 8),
                            Text(
                              "No habits yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 11 : 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 2 : 3),
                            Text(
                              "Add your first habit to start building your ${widget.routineType} routine",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 9 : 11,
                                color: Colors.grey[600],
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 8 : 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isAddingHabit = true;
                                });
                                HapticFeedback.lightImpact();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getRoutineColor(),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 10 : 14,
                                  vertical: isSmallScreen ? 6 : 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 1,
                              ),
                              icon: Icon(Icons.add,
                                  size: isSmallScreen ? 12 : 14),
                              label: Text(
                                "Add Your First Habit",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSmallScreen ? 9 : 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            // Indicator for expanded section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isSmallScreen ? 8 : 12,
              child: Center(
                child: AnimatedOpacity(
                  opacity: isExpanded ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: _getRoutineColor().withOpacity(0.5),
                    size: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
