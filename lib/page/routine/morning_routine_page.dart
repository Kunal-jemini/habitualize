import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MorningRoutinePage extends StatefulWidget {
  final List<String> habits;

  const MorningRoutinePage({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  State<MorningRoutinePage> createState() => _MorningRoutinePageState();
}

class _MorningRoutinePageState extends State<MorningRoutinePage>
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
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
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
        foregroundColor: const Color(0xFFFF7043),
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
                    'Morning Routine',
                    style: GoogleFonts.workSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start your day with energy',
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
                          color: const Color(0xFFFF7043),
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
                    final delay = index * 0.1;
                    final opacity = _animationController.value < delay
                        ? 0.0
                        : (_animationController.value - delay) *
                            (1 / (1 - delay));

                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7043).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getHabitIcon(widget.habits[index]),
                              color: const Color(0xFFFF7043),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            widget.habits[index],
                            style: GoogleFonts.workSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            _getHabitDescription(index),
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Checkbox(
                            value: _completedHabits[index],
                            onChanged: (value) {
                              setState(() {
                                _completedHabits[index] = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFFFF7043),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return Center(
      child: Text(
        'Stats Coming Soon',
        style: GoogleFonts.workSans(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Morning Routine Complete!',
          style: GoogleFonts.workSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7043),
          ),
        ),
        content: Text(
          'Great job! You\'ve completed all your morning habits.',
          style: GoogleFonts.workSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.workSans(
                color: const Color(0xFFFF7043),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getHabitIcon(String habit) {
    final lowerHabit = habit.toLowerCase();
    if (lowerHabit.contains('water')) return Icons.water_drop;
    if (lowerHabit.contains('stretch')) return Icons.fitness_center;
    if (lowerHabit.contains('meditate')) return Icons.self_improvement;
    return Icons.check_circle_outline;
  }

  String _getHabitDescription(int index) {
    switch (index) {
      case 0:
        return 'Start your day with a glass of water to hydrate your body';
      case 1:
        return 'Do some light stretching to wake up your muscles';
      case 2:
        return 'Take a few minutes to meditate and set your intentions';
      default:
        return 'Complete this habit to start your day right';
    }
  }
}
