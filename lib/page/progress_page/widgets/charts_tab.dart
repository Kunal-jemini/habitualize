import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'chart_period_selector.dart';
import 'completion_chart.dart';
import 'habit_distribution.dart';

class ChartsTab extends StatefulWidget {
  const ChartsTab({Key? key}) : super(key: key);

  @override
  State<ChartsTab> createState() => _ChartsTabState();
}

class _ChartsTabState extends State<ChartsTab> {
  int _selectedChartIndex = 0;
  final List<String> _periods = ['Week', 'Month', 'Year'];

  void updateSelectedPeriod(int index) {
    setState(() {
      _selectedChartIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartPeriodSelector(
          periods: _periods,
          selectedIndex: _selectedChartIndex,
          onPeriodSelected: updateSelectedPeriod,
        ),
        const SizedBox(height: 24),
        CompletionChart(
          selectedPeriodIndex: _selectedChartIndex,
          periods: _periods,
        ),
        const SizedBox(height: 24),
        const HabitDistribution(),
      ],
    );
  }
}
