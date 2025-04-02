import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class EveningRoutinePage extends StatefulWidget {
  final List<String> habits;

  const EveningRoutinePage({
    Key? key,
    required this.habits,
  }) : super(key: key);

  @override
  State<EveningRoutinePage> createState() => _EveningRoutinePageState();
}

class _EveningRoutinePageState extends State<EveningRoutinePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<bool> _completedHabits = [];
  int _currentHabitIndex = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    return Scaffold(
      body: Stack(
        children: [
          // Animated background with stars
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
              ),
            ),
            child: CustomPaint(
              painter: StarsPainter(
                animation: _animationController,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with progress
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              'Evening Reflection',
                              style: GoogleFonts.workSans(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress indicator
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_progress * 100).toInt()}% Complete',
                        style: GoogleFonts.workSans(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Moon animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.7 + (0.3 * _animationController.value),
                      child: Opacity(
                        opacity: _animationController.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.nightlight_round,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Relax and unwind text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animationController.value < 0.2
                            ? 0
                            : (_animationController.value - 0.2) * (1 / 0.8),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'Relax & Unwind',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete each step mindfully to prepare for restful sleep',
                          style: GoogleFonts.workSans(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Current step card
                Expanded(
                  child: _buildStepCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard() {
    if (_currentHabitIndex >= widget.habits.length) {
      return _buildCompletionCard();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value < 0.4
              ? 0
              : (_animationController.value - 0.4) * (1 / 0.6),
          child: Transform.translate(
            offset: Offset(
                0,
                50 *
                    (1 -
                        (_animationController.value < 0.4
                            ? 0
                            : (_animationController.value - 0.4) * (1 / 0.6)))),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            // Step number and progress
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3949AB).withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3949AB).withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${_currentHabitIndex + 1}',
                        style: GoogleFonts.workSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3949AB),
                        ),
                      ),
                    ),
                  ),
                  // Step progress indicator
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3949AB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'STEP ${_currentHabitIndex + 1} OF ${widget.habits.length}',
                      style: GoogleFonts.workSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3949AB),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),

            // Step content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Habit title with icon
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3949AB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getHabitIcon(_currentHabitIndex),
                              color: const Color(0xFF3949AB),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.habits[_currentHabitIndex],
                              style: GoogleFonts.workSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Habit description
                      Text(
                        _getHabitDescription(_currentHabitIndex),
                        style: GoogleFonts.workSans(
                          fontSize: 16,
                          color: Colors.black87.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Benefit tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _getHabitBenefits(_currentHabitIndex)
                            .map((benefit) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3949AB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getBenefitIcon(benefit),
                                  size: 14,
                                  color: const Color(0xFF3949AB),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  benefit,
                                  style: GoogleFonts.workSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF3949AB),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Duration and ambient sound info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  color: Color(0xFF3949AB),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Duration',
                                      style: GoogleFonts.workSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '${5 + _currentHabitIndex * 2} minutes',
                                      style: GoogleFonts.workSans(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.music_note,
                                  color: Color(0xFF3949AB),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Suggested Sound',
                                      style: GoogleFonts.workSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      _getAmbientSound(_currentHabitIndex),
                                      style: GoogleFonts.workSans(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        _markCurrentHabitCompleted(false);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'SKIP',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _markCurrentHabitCompleted(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3949AB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        _currentHabitIndex < widget.habits.length - 1
                            ? 'COMPLETE & NEXT'
                            : 'COMPLETE',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    final completedCount = _completedHabits.where((element) => element).length;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Completion animation
            CustomPaint(
              size: const Size(200, 200),
              painter: CompletionPainter(
                progress: _animationController.value,
                color: const Color(0xFF3949AB),
              ),
            ),

            const SizedBox(height: 24),

            // Completion text
            Text(
              'Evening Ritual Complete',
              style: GoogleFonts.workSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'You completed $completedCount out of ${widget.habits.length} steps',
              style: GoogleFonts.workSans(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Sleep well and wake up refreshed!',
              style: GoogleFonts.workSans(
                fontSize: 16,
                color: const Color(0xFF3949AB),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Return button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'RETURN TO HOME',
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markCurrentHabitCompleted(bool completed) {
    setState(() {
      _completedHabits[_currentHabitIndex] = completed;
      _currentHabitIndex++;

      // Update progress
      _progress = _currentHabitIndex / widget.habits.length;

      // Reset animation controller for new step transition
      if (_currentHabitIndex < widget.habits.length) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  String _getHabitDescription(int index) {
    final descriptions = [
      'Reading a book before bed helps calm your mind and prepare your body for sleep. Choose something light and enjoyable that won\'t overstimulate you.',
      'Take a moment to reflect on your day. Acknowledge your accomplishments and let go of any stress or worries. This practice promotes mental clarity and emotional well-being.',
      'Prepare everything you need for tomorrow. Set out clothes, prepare lunch, or review your schedule. This reduces morning stress and helps you sleep better.',
    ];

    if (index < descriptions.length) {
      return descriptions[index];
    }
    return 'This evening habit helps you wind down and prepare for a restful night of sleep. Practice it consistently for best results.';
  }

  List<String> _getHabitBenefits(int index) {
    final benefits = [
      ['Reduces Stress', 'Improves Sleep', 'Mental Stimulation'],
      ['Emotional Health', 'Mindfulness', 'Gratitude'],
      ['Reduces Anxiety', 'Morning Efficiency', 'Peace of Mind'],
    ];

    if (index < benefits.length) {
      return benefits[index];
    }
    return ['Better Sleep', 'Mental Health', 'Relaxation'];
  }

  IconData _getHabitIcon(int index) {
    final icons = [
      Icons.book,
      Icons.psychology,
      Icons.checklist_rtl,
    ];
    return icons[index < icons.length ? index : icons.length - 1];
  }

  IconData _getBenefitIcon(String benefit) {
    switch (benefit.toLowerCase()) {
      case 'reduces stress':
        return Icons.self_improvement;
      case 'improves sleep':
        return Icons.bedtime;
      case 'mental stimulation':
        return Icons.psychology;
      case 'emotional health':
        return Icons.favorite;
      case 'mindfulness':
        return Icons.spa;
      case 'gratitude':
        return Icons.emoji_events;
      case 'reduces anxiety':
        return Icons.air;
      case 'morning efficiency':
        return Icons.rocket_launch;
      case 'peace of mind':
        return Icons.self_improvement;
      default:
        return Icons.star;
    }
  }

  String _getAmbientSound(int index) {
    final sounds = [
      'Gentle Rain',
      'Ocean Waves',
      'White Noise',
    ];
    return sounds[index < sounds.length ? index : sounds.length - 1];
  }
}

class CompletionPainter extends CustomPainter {
  final double progress;
  final Color color;

  CompletionPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Paint for circle
    final circlePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Paint for arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, circlePaint);

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius - 4);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );

    // Draw check mark if progress is complete
    if (progress > 0.9) {
      final checkProgress = (progress - 0.9) * 10; // Scale to 0-1 for last 10%

      final checkPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;

      final path = Path();

      // Calculate check mark points
      final startPoint = Offset(center.dx - radius * 0.3, center.dy);
      final midPoint =
          Offset(center.dx - radius * 0.1, center.dy + radius * 0.2);
      final endPoint =
          Offset(center.dx + radius * 0.3, center.dy - radius * 0.2);

      // First part of check mark
      if (checkProgress <= 0.5) {
        final firstProgress = checkProgress * 2; // Scale 0-0.5 to 0-1
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(
          startPoint.dx + (midPoint.dx - startPoint.dx) * firstProgress,
          startPoint.dy + (midPoint.dy - startPoint.dy) * firstProgress,
        );
      }
      // Complete check mark
      else {
        final secondProgress = (checkProgress - 0.5) * 2; // Scale 0.5-1 to 0-1
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(midPoint.dx, midPoint.dy);
        path.lineTo(
          midPoint.dx + (endPoint.dx - midPoint.dx) * secondProgress,
          midPoint.dy + (endPoint.dy - midPoint.dy) * secondProgress,
        );
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(CompletionPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class StarsPainter extends CustomPainter {
  final Animation<double> animation;

  StarsPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent stars
    final starCount = 50;

    for (var i = 0; i < starCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2;
      final opacity = 0.3 + random.nextDouble() * 0.7;

      paint.color = Colors.white.withOpacity(opacity * animation.value);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => true;
}
