import 'package:flutter/material.dart';
import 'package:habitualize/page/homepage/component_homescreen/habit_routine.dart';
import 'package:habitualize/page/homepage/component_homescreen/profile_section.dart';
import 'package:habitualize/page/homepage/component_homescreen/mood_tracker.dart';
import 'package:habitualize/page/routine/morning_routine_page.dart';
import 'package:habitualize/page/routine/daily_routine_page.dart';
import 'package:habitualize/page/routine/evening_routine_page.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitualizeHome extends StatefulWidget {
  const HabitualizeHome({Key? key}) : super(key: key);

  @override
  State<HabitualizeHome> createState() => _HabitualizeHomeState();
}

class _HabitualizeHomeState extends State<HabitualizeHome> {
  final List<String> morningHabits = ["Drink Water", "Stretch", "Meditate"];
  final List<String> dailyHabits = [
    "Plan Tasks",
    "Take Breaks",
    "Check Emails"
  ];
  final List<String> eveningHabits = [
    "Read a Book",
    "Reflect on Day",
    "Prepare for Sleep"
  ];

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style for a more immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  void _navigateToRoutine(String routineType, List<String> habits) {
    // Create page transition animation
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          // Use specific page for morning routine
          if (routineType == 'Morning') {
            return MorningRoutinePage(
              habits: habits,
            );
          }

          // Use specific page for daily routine
          if (routineType == 'Daily') {
            return DailyRoutinePage(
              habits: habits,
            );
          }

          // Use specific page for evening routine
          if (routineType == 'Evening') {
            return EveningRoutinePage(
              habits: habits,
            );
          }

          // Default to morning routine if type is unknown
          return MorningRoutinePage(
            habits: habits,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildRoutineButton({
    required String title,
    required String routineType,
    required List<String> habits,
    required Color color,
    required IconData icon,
    required double scaleFactor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _navigateToRoutine(routineType, habits);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8 * scaleFactor),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(16 * scaleFactor),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8 * scaleFactor,
              offset: Offset(0, 4 * scaleFactor),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16 * scaleFactor),
            onTap: () {
              HapticFeedback.mediumImpact();
              _navigateToRoutine(routineType, habits);
            },
            child: Padding(
              padding: EdgeInsets.all(16 * scaleFactor),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(12 * scaleFactor),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12 * scaleFactor),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24 * scaleFactor,
                    ),
                  ),
                  SizedBox(width: 16 * scaleFactor),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.workSans(
                            fontSize: 18 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4 * scaleFactor),
                        Text(
                          '${habits.length} habits',
                          style: GoogleFonts.workSans(
                            fontSize: 14 * scaleFactor,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8 * scaleFactor),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16 * scaleFactor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
    final double horizontalPadding =
        isLargeScreen ? 24.0 : (isSmallScreen ? 10.0 : 14.0);
    final double fontSize = isSmallScreen ? 0.8 : (isLargeScreen ? 1.0 : 0.9);

    // Dynamic spacing calculations
    final double sectionSpacing =
        screenSize.height * (isSmallScreen ? 0.008 : 0.012);
    final double bottomPadding =
        screenSize.height * (isSmallScreen ? 0.015 : 0.02);
    final double welcomeMessagePadding =
        isLargeScreen ? 16.0 : (isSmallScreen ? 8.0 : 12.0);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF5F9FC),
                const Color(0xFFEFF6FB),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header with Profile Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4 * fontSize),
                    child: ProfileSection(),
                  ),
                ),

                // Welcome Message
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8 * fontSize),
                      padding: EdgeInsets.all(welcomeMessagePadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF9C27B0).withOpacity(0.7),
                            const Color(0xFF673AB7).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16 * scaleFactor),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withOpacity(0.15),
                            blurRadius: 8 * scaleFactor,
                            offset: Offset(0, 4 * scaleFactor),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6 * fontSize),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius:
                                      BorderRadius.circular(12 * scaleFactor),
                                ),
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: screenSize.width > 320
                                      ? 18 * scaleFactor
                                      : 16 * scaleFactor,
                                ),
                              ),
                              SizedBox(width: 8 * fontSize),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today is a great day to build habits!',
                                      style: GoogleFonts.workSans(
                                        fontSize: screenSize.width > 320
                                            ? 14 * scaleFactor
                                            : 12 * scaleFactor,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 2 * fontSize),
                                    Text(
                                      'Check in with your routines below',
                                      style: GoogleFonts.workSans(
                                        fontSize: screenSize.width > 320
                                            ? 11 * scaleFactor
                                            : 10 * scaleFactor,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Habit Routines - Using SliverFillRemaining to prevent overflow
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPadding * 0.8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildRoutineButton(
                        title: "Morning Routine",
                        routineType: "Morning",
                        habits: morningHabits,
                        color: const Color(0xFFFF7043),
                        icon: Icons.wb_sunny,
                        scaleFactor: scaleFactor,
                      ),
                      _buildRoutineButton(
                        title: "Daily Routine",
                        routineType: "Daily",
                        habits: dailyHabits,
                        color: const Color(0xFF00ACC1),
                        icon: Icons.access_time,
                        scaleFactor: scaleFactor,
                      ),
                      _buildRoutineButton(
                        title: "Evening Routine",
                        routineType: "Evening",
                        habits: eveningHabits,
                        color: const Color(0xFF3949AB),
                        icon: Icons.nightlight_round,
                        scaleFactor: scaleFactor,
                      ),
                      SizedBox(height: sectionSpacing),
                      const MoodTracker(),
                      // Add bottom padding for scroll safety - responsive to screen height
                      SizedBox(height: bottomPadding),
                    ]),
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
