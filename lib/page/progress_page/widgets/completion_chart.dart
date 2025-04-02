import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompletionChart extends StatelessWidget {
  final int selectedPeriodIndex;
  final List<String> periods;

  const CompletionChart({
    Key? key,
    required this.selectedPeriodIndex,
    required this.periods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            'Last ${periods[selectedPeriodIndex].toLowerCase()}',
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
                maxX: selectedPeriodIndex == 0
                    ? 6
                    : (selectedPeriodIndex == 1 ? 29 : 11),
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
      axisSide: meta.axisSide,
      child: Text(text, style: style, textAlign: TextAlign.center),
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
    if (selectedPeriodIndex == 0) {
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
    } else if (selectedPeriodIndex == 1) {
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
      axisSide: meta.axisSide,
      child: text,
      space: 8,
    );
  }

  List<FlSpot> _getChartData() {
    if (selectedPeriodIndex == 0) {
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
    } else if (selectedPeriodIndex == 1) {
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
}
