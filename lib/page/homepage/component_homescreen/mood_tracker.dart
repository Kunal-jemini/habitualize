import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mood_tracking_view.dart';
import 'dart:ui';

class MoodTracker extends StatefulWidget {
  const MoodTracker({Key? key}) : super(key: key);

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker>
    with SingleTickerProviderStateMixin {
  int? selectedMoodIndex;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Animation<double>? _rotateAnimation;
  bool _isLoading = false;

  final List<Map<String, dynamic>> moods = [
    {
      'icon': Icons.sentiment_very_satisfied,
      'label': 'Very Happy',
      'color': const Color(0xFF4CAF50),
      'gradientColors': const [Color(0xFF4CAF50), Color(0xFF81C784)],
      'emoji': '😄',
    },
    {
      'icon': Icons.sentiment_satisfied,
      'label': 'Happy',
      'color': const Color(0xFFFFC107),
      'gradientColors': const [Color(0xFFFFC107), Color(0xFFFFD54F)],
      'emoji': '😊',
    },
    {
      'icon': Icons.sentiment_neutral,
      'label': 'Neutral',
      'color': const Color(0xFF9E9E9E),
      'gradientColors': const [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
      'emoji': '😐',
    },
    {
      'icon': Icons.sentiment_dissatisfied,
      'label': 'Sad',
      'color': const Color(0xFF2196F3),
      'gradientColors': const [Color(0xFF2196F3), Color(0xFF64B5F6)],
      'emoji': '😔',
    },
    {
      'icon': Icons.mood_bad,
      'label': 'Angry',
      'color': const Color(0xFFF44336),
      'gradientColors': const [Color(0xFFF44336), Color(0xFFE57373)],
      'emoji': '😡',
    },
  ];

  // Safe getter methods to avoid null errors
  Color getSelectedColor() {
    if (selectedMoodIndex == null || selectedMoodIndex! >= moods.length) {
      return Colors.grey;
    }
    return moods[selectedMoodIndex!]['color'] as Color? ?? Colors.grey;
  }

  String getSelectedLabel() {
    if (selectedMoodIndex == null || selectedMoodIndex! >= moods.length) {
      return 'neutral';
    }
    return moods[selectedMoodIndex!]['label'] as String? ?? 'neutral';
  }

  String getSelectedEmoji() {
    if (selectedMoodIndex == null || selectedMoodIndex! >= moods.length) {
      return '😐';
    }
    return moods[selectedMoodIndex!]['emoji'] as String? ?? '😐';
  }

  List<Color> getSelectedGradient() {
    if (selectedMoodIndex == null || selectedMoodIndex! >= moods.length) {
      return [Colors.grey, Colors.grey.withOpacity(0.7)];
    }
    final gradientColors = moods[selectedMoodIndex!]['gradientColors'];
    if (gradientColors is List<Color> && gradientColors.length >= 2) {
      return gradientColors;
    }
    final color = getSelectedColor();
    return [color, color.withOpacity(0.7)];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Safely initialize _rotateAnimation
    try {
      _rotateAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    } catch (e) {
      debugPrint('Error initializing animations: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectMood(int index) async {
    // Play haptic feedback
    HapticFeedback.mediumImpact();

    if (selectedMoodIndex == index) {
      setState(() {
        selectedMoodIndex = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      selectedMoodIndex = index;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final double padding = isSmallScreen ? 20.0 : 24.0;
    final double fontSize = isSmallScreen ? 0.85 : 0.95;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            decoration: BoxDecoration(
              color: selectedMoodIndex != null
                  ? getSelectedColor().withOpacity(0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selectedMoodIndex != null
                    ? getSelectedColor().withOpacity(0.1)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      padding, padding, padding, padding * 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mood,
                                color: selectedMoodIndex != null
                                    ? getSelectedColor()
                                    : Colors.grey[700],
                                size: 24 * fontSize,
                              ),
                              SizedBox(width: 10 * fontSize),
                              Text(
                                'How are you feeling?',
                                style: TextStyle(
                                  fontSize: 20 * fontSize,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4 * fontSize),
                          Padding(
                            padding: EdgeInsets.only(left: 34 * fontSize),
                            child: Text(
                              selectedMoodIndex != null
                                  ? 'You\'re feeling ${getSelectedLabel().toLowerCase()} today'
                                  : 'Track your mood for better self-awareness',
                              style: TextStyle(
                                fontSize: 12 * fontSize,
                                color: selectedMoodIndex != null
                                    ? getSelectedColor()
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Mood Emoji Row if selected
                if (selectedMoodIndex != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12 * fontSize),
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    decoration: BoxDecoration(
                      color: getSelectedColor().withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getSelectedEmoji(),
                          style: TextStyle(
                            fontSize: 40 * fontSize,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 10 * fontSize),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getSelectedLabel(),
                              style: TextStyle(
                                fontSize: 18 * fontSize,
                                fontWeight: FontWeight.w600,
                                color: getSelectedColor(),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12 * fontSize,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4 * fontSize),
                                Text(
                                  'Today, ${_getCurrentTime()}',
                                  style: TextStyle(
                                    fontSize: 11 * fontSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 20 * fontSize),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MoodTrackingView(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12 * fontSize,
                                vertical: 6 * fontSize,
                              ),
                              decoration: BoxDecoration(
                                color: getSelectedColor().withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bar_chart,
                                    color: getSelectedColor(),
                                    size: 16 * fontSize,
                                  ),
                                  SizedBox(width: 6 * fontSize),
                                  Text(
                                    'View Stats',
                                    style: TextStyle(
                                      color: getSelectedColor(),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12 * fontSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Mood Selection
                Container(
                  height: selectedMoodIndex != null ? 90 : 110,
                  margin:
                      EdgeInsets.fromLTRB(0, 12 * fontSize, 0, 18 * fontSize),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final mood = moods[index];
                      return _buildMoodOption(
                        mood['icon'] as IconData? ?? Icons.mood,
                        mood['label'] as String? ?? 'Mood',
                        mood['color'] as Color? ?? Colors.grey,
                        mood['gradientColors'] is List<Color>
                            ? mood['gradientColors'] as List<Color>
                            : [
                                mood['color'] as Color? ?? Colors.grey,
                                (mood['color'] as Color? ?? Colors.grey)
                                    .withOpacity(0.7)
                              ],
                        mood['emoji'] as String? ?? '😐',
                        index,
                      );
                    },
                  ),
                ),

                // Tips Section
                if (selectedMoodIndex != null)
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        padding, 0, padding, padding * 0.75),
                    padding: EdgeInsets.all(12 * fontSize),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10 * fontSize),
                          decoration: BoxDecoration(
                            color: getSelectedColor().withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: getSelectedColor(),
                            size: 20 * fontSize,
                          ),
                        ),
                        SizedBox(width: 12 * fontSize),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getMoodTipTitle(selectedMoodIndex ?? 0),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14 * fontSize,
                                ),
                              ),
                              SizedBox(height: 3 * fontSize),
                              Text(
                                _getMoodTip(selectedMoodIndex ?? 0),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12 * fontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    final formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  String _getMoodTipTitle(int index) {
    final titles = [
      'Great job!',
      'Enjoying your day?',
      'Be mindful today',
      'Need a boost?',
      'Take care of yourself',
    ];
    return index < titles.length ? titles[index] : titles[0];
  }

  String _getMoodTip(int index) {
    final tips = [
      'Share your positive energy with others around you.',
      'Try to notice what\'s making you happy and do more of it.',
      'Practice mindfulness to stay present throughout your day.',
      'Taking a short walk or calling a friend might help lift your mood.',
      'It\'s okay to take a break when you need it. Practice self-care today.',
    ];
    return index < tips.length ? tips[index] : tips[0];
  }

  Widget _buildMoodOption(
    IconData icon,
    String label,
    Color color,
    List<Color> gradient,
    String emoji,
    int index,
  ) {
    final isSelected = selectedMoodIndex == index;
    final rotationValue =
        (isSelected && _animationController.status == AnimationStatus.forward)
            ? (_rotateAnimation?.value ?? 0)
            : 0.0;

    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final double scale = isSmallScreen ? 0.85 : 0.95;

    return AnimatedScale(
      scale: isSelected ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedRotation(
        turns: rotationValue,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: () => _selectMood(index),
          child: Container(
            width: 90 * scale,
            margin: EdgeInsets.only(right: 12 * scale),
            decoration: BoxDecoration(
              color: isSelected ? null : Colors.white,
              gradient: isSelected
                  ? LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade200,
                width: isSelected ? 1.5 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.25),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.06),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading && isSelected
                    ? SizedBox(
                        width: 32 * scale,
                        height: 32 * scale,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isSelected ? Colors.white : color,
                          ),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isSelected)
                            Container(
                              padding: EdgeInsets.all(5 * scale),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            emoji,
                            style: TextStyle(
                              fontSize: 34 * scale,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 8 * scale),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * scale,
                    vertical: 3 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.3)
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11 * scale,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : color,
                    ),
                    textAlign: TextAlign.center,
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
