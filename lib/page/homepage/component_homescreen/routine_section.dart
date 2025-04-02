import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habitualize/page/routine/routine_detail_page.dart';
import 'package:habitualize/page/routine/morning_routine_page.dart';
import 'package:habitualize/page/routine/daily_routine_page.dart';
import 'package:habitualize/page/routine/evening_routine_page.dart';

class RoutineSection extends StatelessWidget {
  final String title;
  final String routineType;
  final List<String> defaultHabits;

  const RoutineSection({
    Key? key,
    required this.title,
    required this.routineType,
    required this.defaultHabits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final double scaleFactor = isSmallScreen ? 0.85 : 1.0;

    return Container(
      padding: EdgeInsets.all(16 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scaleFactor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10 * scaleFactor,
            offset: Offset(0, 4 * scaleFactor),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _getRoutineIcon(),
                  SizedBox(width: 12 * scaleFactor),
                  Text(
                    title,
                    style: GoogleFonts.workSans(
                      fontSize: 18 * scaleFactor,
                      fontWeight: FontWeight.w600,
                      color: _getRoutineColor(),
                    ),
                  ),
                ],
              ),
              _buildCompletionIndicator(scaleFactor),
            ],
          ),
          SizedBox(height: 16 * scaleFactor),

          // Habits preview
          ...List.generate(
            defaultHabits.length > 2 ? 2 : defaultHabits.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 10 * scaleFactor),
              child: Row(
                children: [
                  Container(
                    width: 20 * scaleFactor,
                    height: 20 * scaleFactor,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12 * scaleFactor,
                      color: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 12 * scaleFactor),
                  Text(
                    defaultHabits[index],
                    style: GoogleFonts.workSans(
                      fontSize: 14 * scaleFactor,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // More indicator if there are more than 2 habits
          if (defaultHabits.length > 2)
            Padding(
              padding:
                  EdgeInsets.only(left: 32 * scaleFactor, top: 5 * scaleFactor),
              child: Text(
                '+ ${defaultHabits.length - 2} more',
                style: GoogleFonts.workSans(
                  fontSize: 12 * scaleFactor,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          SizedBox(height: 16 * scaleFactor),

          // Open button
          InkWell(
            onTap: () {
              _openRoutineDetailPage(context);
            },
            borderRadius: BorderRadius.circular(12 * scaleFactor),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
              decoration: BoxDecoration(
                color: _getRoutineColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12 * scaleFactor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Your ${routineType} Routine',
                    style: GoogleFonts.workSans(
                      fontSize: 14 * scaleFactor,
                      fontWeight: FontWeight.w600,
                      color: _getRoutineColor(),
                    ),
                  ),
                  SizedBox(width: 8 * scaleFactor),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12 * scaleFactor,
                    color: _getRoutineColor(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionIndicator(double scaleFactor) {
    // This would be connected to actual progress in a real app
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scaleFactor,
        vertical: 6 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: _getRoutineColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(30 * scaleFactor),
      ),
      child: Text(
        '0/${defaultHabits.length}',
        style: GoogleFonts.workSans(
          fontSize: 12 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: _getRoutineColor(),
        ),
      ),
    );
  }

  Icon _getRoutineIcon() {
    switch (routineType) {
      case 'Morning':
        return const Icon(Icons.wb_sunny, color: Color(0xFFFF7043));
      case 'Daily':
        return const Icon(Icons.access_time, color: Color(0xFF00ACC1));
      case 'Evening':
        return const Icon(Icons.nightlight_round, color: Color(0xFF3949AB));
      default:
        return const Icon(Icons.list, color: Color(0xFF673AB7));
    }
  }

  Color _getRoutineColor() {
    switch (routineType) {
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

  void _openRoutineDetailPage(BuildContext context) {
    // Create page transition animation
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          // Use specific page for morning routine
          if (routineType == 'Morning') {
            return MorningRoutinePage(
              habits: defaultHabits,
            );
          }

          // Use specific page for daily routine
          if (routineType == 'Daily') {
            return DailyRoutinePage(
              habits: defaultHabits,
            );
          }

          // Use specific page for evening routine
          if (routineType == 'Evening') {
            return EveningRoutinePage(
              habits: defaultHabits,
            );
          }

          // Use generic page for other routines
          return RoutineDetailPage(
            routineType: routineType,
            habits: defaultHabits,
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
}
