import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyRoutinePage extends StatefulWidget {
  final List<String> habits;

  const DailyRoutinePage({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  State<DailyRoutinePage> createState() => _DailyRoutinePageState();
}

class _DailyRoutinePageState extends State<DailyRoutinePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  final List<bool> _completedHabits = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    _tabController.dispose();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 16.0, top: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          indicatorWeight: 3,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.7),
                          labelStyle: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          onTap: (index) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          tabs: const [
                            Tab(text: 'HABITS'),
                            Tab(text: 'STATS'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    _tabController.animateTo(index);
                  },
                  children: [
                    // Habits tab
                    _buildHabitsTab(),

                    // Stats tab
                    _buildStatsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show completion dialog when all habits are completed
          if (_completedHabits.every((element) => element)) {
            _showCompletionDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Complete all tasks to finish your routine',
                  style: GoogleFonts.workSans(),
                ),
                backgroundColor: Colors.blueGrey[700],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF00ACC1),
        elevation: 4,
        icon: const Icon(Icons.check_circle_outline),
        label: Text(
          'COMPLETE ROUTINE',
          style: GoogleFonts.workSans(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHabitsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Routine',
                    style: GoogleFonts.workSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stay focused and consistent',
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Progress indicator
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final progress = _completedHabits.isEmpty
                    ? 0.0
                    : _completedHabits.where((element) => element).length /
                        _completedHabits.length;

                return Opacity(
                  opacity: _animationController.value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Progress',
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress * _animationController.value,
                          backgroundColor: Colors.grey[200],
                          color: const Color(0xFF00ACC1),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(_completedHabits.where((element) => element).length)} of ${_completedHabits.length} completed',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Habits list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.habits.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final delay = index * 0.15;
                    final startValue = delay;
                    final endValue = delay + 0.6;
                    final animationValue = _animationController.value;

                    final opacity = animationValue < startValue
                        ? 0.0
                        : animationValue > endValue
                            ? 1.0
                            : (animationValue - startValue) /
                                (endValue - startValue);

                    final slideValue = animationValue < startValue
                        ? 30.0
                        : animationValue > endValue
                            ? 0.0
                            : 30.0 -
                                (30.0 *
                                    (animationValue - startValue) /
                                    (endValue - startValue));

                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, slideValue),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.0),
                            onTap: () {
                              setState(() {
                                _completedHabits[index] =
                                    !_completedHabits[index];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Checkbox
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _completedHabits[index]
                                          ? const Color(0xFF00ACC1)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _completedHabits[index]
                                            ? const Color(0xFF00ACC1)
                                            : Colors.grey.withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: _completedHabits[index]
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),

                                  // Habit details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.habits[index],
                                          style: GoogleFonts.workSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: _completedHabits[index]
                                                ? Colors.grey
                                                : Colors.black87,
                                            decoration: _completedHabits[index]
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 12,
                                              color: Colors.grey[500],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${5 + index * 2} minutes',
                                              style: GoogleFonts.workSans(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.show_chart,
                                              size: 12,
                                              color: Colors.teal[400],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Productivity',
                                              style: GoogleFonts.workSans(
                                                fontSize: 12,
                                                color: Colors.teal[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Habit icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00ACC1)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getIconForHabit(index),
                                      color: const Color(0xFF00ACC1),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Bottom space for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    final habits = _completedHabits.where((element) => element).length;
    final total = _completedHabits.length;
    final completionRate =
        total > 0 ? (habits / total * 100).toStringAsFixed(0) : '0';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 20.0),
              child: Text(
                'Your Statistics',
                style: GoogleFonts.workSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Main stats card
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Today\'s Completion',
                    style: GoogleFonts.workSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: habits / (total > 0 ? total : 1),
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          color: const Color(0xFF00ACC1),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$completionRate%',
                            style: GoogleFonts.workSans(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00ACC1),
                            ),
                          ),
                          Text(
                            'Completed',
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(habits.toString(), 'Tasks Done'),
                      _buildStatItem((total - habits).toString(), 'Remaining'),
                      _buildStatItem('${(habits * 10)}', 'Points'),
                    ],
                  ),
                ],
              ),
            ),

            // Daily streaks card
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.deepOrange,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Your Streak',
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      7,
                      (index) => _buildDayIndicator(
                        day: ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                        completed: index < 5, // Mock data
                        isToday: index == 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Current streak: 5 days',
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom space for FAB
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.workSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.workSans(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDayIndicator(
      {required String day, required bool completed, required bool isToday}) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isToday
                ? const Color(0xFF00ACC1)
                : completed
                    ? const Color(0xFF00ACC1).withOpacity(0.7)
                    : Colors.grey[200],
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: Colors.white, width: 2) : null,
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: const Color(0xFF00ACC1).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              completed ? Icons.check : Icons.close,
              color: completed || isToday ? Colors.white : Colors.grey[400],
              size: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: GoogleFonts.workSans(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: isToday ? const Color(0xFF00ACC1) : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  IconData _getIconForHabit(int index) {
    final icons = [
      Icons.checklist,
      Icons.free_breakfast,
      Icons.mail_outline,
    ];

    if (index < icons.length) {
      return icons[index];
    }
    return Icons.check_circle_outline;
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00ACC1).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 40,
                    color: Color(0xFF00ACC1),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Daily Routine Complete!',
                  style: GoogleFonts.workSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You\'ve earned 30 points and kept your streak going!',
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Return to main screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ACC1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'BACK TO HOME',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
