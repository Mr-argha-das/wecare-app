import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyWorkGraph extends StatelessWidget {
  final List hours;

  const WeeklyWorkGraph({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    final values = hours
        .map<double>((e) => (e["hours"] ?? 0).toDouble())
        .toList();

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0, // 🔥 important
          maxY: 12, // adjust based on max hours
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 3,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.2), dashArray: [6, 6]),
          ),
          borderData: FlBorderData(
            show: false, // 🔥 remove ugly border
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 3,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun",
                  ];
                  if (value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                values.length,
                (i) => FlSpot(i.toDouble(), values[i]),
              ),
              isCurved: true,
              preventCurveOverShooting: true, // 🔥 negative dip fix
              color: Colors.teal,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: Colors.teal,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
