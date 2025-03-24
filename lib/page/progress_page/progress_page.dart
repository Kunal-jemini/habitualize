import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Scroll controllers for each tab
  late ScrollController _habitsScrollController;
  late ScrollController _chartsScrollController;
  late ScrollController _insightsScrollController;

  // Track if we should show the scroll-to-top button
  bool _showHabitsScrollTopButton = false;
  bool _showChartsScrollTopButton = false;
  bool _showInsightsScrollTopButton = false;

  int _selectedChartIndex = 0;
  final List<String> _periods = ['Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Initialize scroll controllers
    _habitsScrollController = ScrollController();
    _chartsScrollController = ScrollController();
    _insightsScrollController = ScrollController();

    // Add scroll listeners to track position for scroll-to-top button
    _habitsScrollController.addListener(() {
      setState(() {
        _showHabitsScrollTopButton = _habitsScrollController.offset > 300;
      });
    });

    _chartsScrollController.addListener(() {
      setState(() {
        _showChartsScrollTopButton = _chartsScrollController.offset > 300;
      });
    });

    _insightsScrollController.addListener(() {
      setState(() {
        _showInsightsScrollTopButton = _insightsScrollController.offset > 300;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _habitsScrollController.dispose();
    _chartsScrollController.dispose();
    _insightsScrollController.dispose();
    super.dispose();
  }

  // Helper method to get the current scroll controller
  ScrollController _getCurrentScrollController() {
    switch (_tabController.index) {
      case 0:
        return _habitsScrollController;
      case 1:
        return _chartsScrollController;
      case 2:
        return _insightsScrollController;
      default:
        return _habitsScrollController;
    }
  }

  // Helper method to get current "show scroll top button" state
  bool _getCurrentShowScrollTopButton() {
    switch (_tabController.index) {
      case 0:
        return _showHabitsScrollTopButton;
      case 1:
        return _showChartsScrollTopButton;
      case 2:
        return _showInsightsScrollTopButton;
      default:
        return false;
    }
  }

  // Scroll to top method
  void _scrollToTop() {
    _getCurrentScrollController().animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBarWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCards(),
                        const SizedBox(height: 16),
                        _buildTabBar(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Scrollbar(
                          controller: _habitsScrollController,
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            controller: _habitsScrollController,
                            padding: const EdgeInsets.all(16),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            child: _buildHabitsTab(),
                          ),
                        ),
                        Scrollbar(
                          controller: _chartsScrollController,
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            controller: _chartsScrollController,
                            padding: const EdgeInsets.all(16),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            child: _buildChartsTab(),
                          ),
                        ),
                        Scrollbar(
                          controller: _insightsScrollController,
                          thumbVisibility: true,
                          thickness: 6,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            controller: _insightsScrollController,
                            padding: const EdgeInsets.all(16),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            child: _buildInsightsTab(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Scroll-to-top floating action button
              if (_getCurrentShowScrollTopButton())
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: AnimatedOpacity(
                    opacity: _getCurrentShowScrollTopButton() ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.green.shade600,
                      onPressed: _scrollToTop,
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarWidget() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade300,
            Colors.green.shade700,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Title
          Positioned(
            bottom: 16,
            left: 16,
            child: const Text(
              'Your Progress',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildSummaryCard('Daily Streak', '12 days',
                      Icons.local_fire_department, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildSummaryCard(
                      'Completed', '85%', Icons.task_alt, Colors.green)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildSummaryCard('Total Habits', '24',
                      Icons.format_list_bulleted, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildSummaryCard('Mood Average', 'Good',
                      Icons.sentiment_satisfied_alt, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.green.shade600,
              width: 3,
            ),
          ),
        ),
        tabs: const [
          Tab(text: 'Habits'),
          Tab(text: 'Charts'),
          Tab(text: 'Insights'),
        ],
      ),
    );
  }

  Widget _buildHabitsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Performing Habits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildHabitProgressItem('Morning Meditation', 0.95, Colors.green),
        const SizedBox(height: 12),
        _buildHabitProgressItem('Reading', 0.8, Colors.purple),
        const SizedBox(height: 12),
        _buildHabitProgressItem('Exercise', 0.75, Colors.red),
        const SizedBox(height: 12),
        _buildHabitProgressItem('Drinking Water', 0.7, Colors.blue),
        const SizedBox(height: 24),
        const Text(
          'Needs Improvement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildHabitProgressItem('Journaling', 0.4, Colors.orange),
        const SizedBox(height: 12),
        _buildHabitProgressItem('Early Sleep', 0.3, Colors.indigo),
      ],
    );
  }

  Widget _buildHabitProgressItem(String title, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getHabitIcon(title),
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: progress,
            backgroundColor: Colors.grey[200],
            progressColor: color,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartPeriodSelector(),
        const SizedBox(height: 24),
        _buildCompletionChart(),
        const SizedBox(height: 24),
        _buildHabitDistribution(),
      ],
    );
  }

  Widget _buildChartPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_periods.length, (index) {
          bool isSelected = index == _selectedChartIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedChartIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _periods[index],
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCompletionChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Habit Completion Rate',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last ${_periods[_selectedChartIndex].toLowerCase()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    );
                  },
                  drawVerticalLine: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: _bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      getTitlesWidget: _leftTitleWidgets,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                minX: 0,
                maxX: _selectedChartIndex == 0
                    ? 6
                    : (_selectedChartIndex == 1 ? 29 : 11),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.green,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Habit Category Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: 35,
                    title: '35%',
                    color: Colors.blue,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: '25%',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: '20%',
                    color: Colors.purple,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: '20%',
                    color: Colors.orange,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryLegend('Health & Fitness', 35, Colors.blue),
          const SizedBox(height: 8),
          _buildCategoryLegend('Productivity', 25, Colors.green),
          const SizedBox(height: 8),
          _buildCategoryLegend('Mindfulness', 20, Colors.purple),
          const SizedBox(height: 8),
          _buildCategoryLegend('Learning', 20, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildCategoryLegend(String category, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          category,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          '$percentage%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInsightCard(
          'Great Consistency!',
          "You've completed your meditation habit 12 days in a row. Keep up the good work!",
          Icons.celebration,
          Colors.amber,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Time to Focus',
          'Your productivity seems to peak in the morning. Consider scheduling important tasks early in the day.',
          Icons.lightbulb,
          Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'Improvement Needed',
          "You've been missing your early sleep habit. Try setting a reminder 30 minutes before bedtime.",
          Icons.tips_and_updates,
          Colors.red,
        ),
        const SizedBox(height: 16),
        _buildInsightCard(
          'New Milestone!',
          "You've tracked habits for 30 days straight! That's a sign of great dedication.",
          Icons.emoji_events,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildInsightCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      color: Colors.grey,
    );

    String text;
    switch (value.toInt()) {
      case 0:
        text = '0%';
        break;
      case 25:
        text = '25%';
        break;
      case 50:
        text = '50%';
        break;
      case 75:
        text = '75%';
        break;
      case 100:
        text = '100%';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      child: Text(text, style: style, textAlign: TextAlign.center),
      meta: meta,
      space: 8,
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 12,
      color: Colors.grey,
    );

    Widget text;
    // Different x-axis labels based on selected period
    if (_selectedChartIndex == 0) {
      // Week
      switch (value.toInt()) {
        case 0:
          text = const Text('Mon', style: style);
          break;
        case 1:
          text = const Text('Tue', style: style);
          break;
        case 2:
          text = const Text('Wed', style: style);
          break;
        case 3:
          text = const Text('Thu', style: style);
          break;
        case 4:
          text = const Text('Fri', style: style);
          break;
        case 5:
          text = const Text('Sat', style: style);
          break;
        case 6:
          text = const Text('Sun', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    } else if (_selectedChartIndex == 1) {
      // Month
      if (value % 7 == 0) {
        final weekNum = (value / 7 + 1).toInt();
        text = Text('W$weekNum', style: style);
      } else {
        text = const Text('', style: style);
      }
    } else {
      // Year
      switch (value.toInt()) {
        case 0:
          text = const Text('Jan', style: style);
          break;
        case 1:
          text = const Text('Feb', style: style);
          break;
        case 2:
          text = const Text('Mar', style: style);
          break;
        case 3:
          text = const Text('Apr', style: style);
          break;
        case 4:
          text = const Text('May', style: style);
          break;
        case 5:
          text = const Text('Jun', style: style);
          break;
        case 6:
          text = const Text('Jul', style: style);
          break;
        case 7:
          text = const Text('Aug', style: style);
          break;
        case 8:
          text = const Text('Sep', style: style);
          break;
        case 9:
          text = const Text('Oct', style: style);
          break;
        case 10:
          text = const Text('Nov', style: style);
          break;
        case 11:
          text = const Text('Dec', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    }

    return SideTitleWidget(
      child: text,
      meta: meta,
      space: 8,
    );
  }

  List<FlSpot> _getChartData() {
    if (_selectedChartIndex == 0) {
      // Week
      return [
        const FlSpot(0, 60),
        const FlSpot(1, 65),
        const FlSpot(2, 78),
        const FlSpot(3, 70),
        const FlSpot(4, 85),
        const FlSpot(5, 90),
        const FlSpot(6, 88),
      ];
    } else if (_selectedChartIndex == 1) {
      // Month
      List<FlSpot> spots = [];
      for (int i = 0; i < 30; i++) {
        spots.add(FlSpot(i.toDouble(), 50 + (i % 5) * 10 + (i % 3) * 5));
      }
      return spots;
    } else {
      // Year
      return [
        const FlSpot(0, 65),
        const FlSpot(1, 68),
        const FlSpot(2, 72),
        const FlSpot(3, 75),
        const FlSpot(4, 70),
        const FlSpot(5, 75),
        const FlSpot(6, 80),
        const FlSpot(7, 85),
        const FlSpot(8, 80),
        const FlSpot(9, 85),
        const FlSpot(10, 88),
        const FlSpot(11, 92),
      ];
    }
  }

  IconData _getHabitIcon(String habit) {
    switch (habit.toLowerCase()) {
      case 'morning meditation':
        return Icons.self_improvement;
      case 'reading':
        return Icons.menu_book;
      case 'exercise':
        return Icons.fitness_center;
      case 'drinking water':
        return Icons.water_drop;
      case 'journaling':
        return Icons.edit_note;
      case 'early sleep':
        return Icons.bedtime;
      default:
        return Icons.check_circle;
    }
  }
}
