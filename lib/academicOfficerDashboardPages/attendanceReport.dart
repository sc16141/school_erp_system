import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  bool _isLoading = true;

  // Sample data - replace with actual data from your service
  Map<String, dynamic> _attendanceData = {
    'overall': {
      'totalStudents': 450,
      'totalTeachers': 35,
      'presentStudents': 380,
      'presentTeachers': 32,
      'absentStudents': 45,
      'absentTeachers': 2,
      'lateStudents': 25,
      'lateTeachers': 1,
    },
    'weeklyData': [
      {'day': 'Mon', 'present': 85, 'absent': 10, 'late': 5},
      {'day': 'Tue', 'present': 88, 'absent': 8, 'late': 4},
      {'day': 'Wed', 'present': 82, 'absent': 12, 'late': 6},
      {'day': 'Thu', 'present': 90, 'absent': 7, 'late': 3},
      {'day': 'Fri', 'present': 84, 'absent': 11, 'late': 5},
    ],
    'monthlyTrend': [
      {'month': 'Jan', 'percentage': 87},
      {'month': 'Feb', 'percentage': 89},
      {'month': 'Mar', 'percentage': 85},
      {'month': 'Apr', 'percentage': 91},
      {'month': 'May', 'percentage': 88},
      {'month': 'Jun', 'percentage': 90},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(color: AppThemeColor.white),
          )
              : SingleChildScrollView(
            padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
            child: Column(
              children: [
                HeaderSection(
                  title: 'Attendance Report',
                  icon: Icons.analytics,
                ),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildOverallStats(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildWeeklyChart(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildMonthlyTrendChart(),
                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                _buildAttendancePieChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStats() {
    final overall = _attendanceData['overall'] as Map<String, dynamic>;
    final studentAttendanceRate =
    (overall['presentStudents'] / overall['totalStudents'] * 100).round();
    final teacherAttendanceRate =
    (overall['presentTeachers'] / overall['totalTeachers'] * 100).round();

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Students',
                  '${overall['presentStudents']}/${overall['totalStudents']}',
                  '$studentAttendanceRate%',
                  Icons.school,
                  Colors.blue,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildStatCard(
                  'Teachers',
                  '${overall['presentTeachers']}/${overall['totalTeachers']}',
                  '$teacherAttendanceRate%',
                  Icons.person,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String percentage,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context)),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(title, style: AppThemeResponsiveness.getBodyTextStyle(context)),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
            ),
          ),
          Text(
            percentage,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Attendance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final weeklyData = _attendanceData['weeklyData'] as List<dynamic>;
                        final dayIndex = (value.toInt() / 3).floor();
                        if (value.toInt() % 3 == 1 && dayIndex < weeklyData.length) {
                          return Text(
                            weeklyData[dayIndex]['day'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          _buildChartLegend(),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final weeklyData = _attendanceData['weeklyData'] as List<dynamic>;
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < weeklyData.length; i++) {
      final data = weeklyData[i] as Map<String, dynamic>;
      groups.add(BarChartGroupData(
        x: i * 3, // Present bars
        barRods: [
          BarChartRodData(
            toY: (data['present'] as int).toDouble(),
            color: Colors.green,
            width: 8,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ));

      groups.add(BarChartGroupData(
        x: i * 3 + 1, // Absent bars
        barRods: [
          BarChartRodData(
            toY: (data['absent'] as int).toDouble(),
            color: Colors.red,
            width: 8,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ));

      groups.add(BarChartGroupData(
        x: i * 3 + 2, // Late bars
        barRods: [
          BarChartRodData(
            toY: (data['late'] as int).toDouble(),
            color: Colors.orange,
            width: 8,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ));
    }

    return groups;
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Present', Colors.green),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        _buildLegendItem('Absent', Colors.red),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        _buildLegendItem('Late', Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(label, style: AppThemeResponsiveness.getBodyTextStyle(context)),
      ],
    );
  }

  Widget _buildMonthlyTrendChart() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Attendance Trend',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final monthlyData = _attendanceData['monthlyTrend'] as List<dynamic>;
                        if (value.toInt() < monthlyData.length) {
                          return Text(
                            monthlyData[value.toInt()]['month'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _buildLineChartSpots(),
                    isCurved: true,
                    color: AppThemeColor.primaryBlue,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppThemeColor.primaryBlue.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
                minY: 80,
                maxY: 95,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildLineChartSpots() {
    final monthlyData = _attendanceData['monthlyTrend'] as List<dynamic>;
    List<FlSpot> spots = [];

    for (int i = 0; i < monthlyData.length; i++) {
      final data = monthlyData[i] as Map<String, dynamic>;
      spots.add(FlSpot(
        i.toDouble(),
        (data['percentage'] as int).toDouble(),
      ));
    }

    return spots;
  }

  Widget _buildAttendancePieChart() {
    final overall = _attendanceData['overall'] as Map<String, dynamic>;
    final totalStudents = overall['totalStudents'] as int;
    final presentStudents = overall['presentStudents'] as int;
    final absentStudents = overall['absentStudents'] as int;
    final lateStudents = overall['lateStudents'] as int;

    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Attendance Distribution',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: presentStudents.toDouble(),
                    title: '${(presentStudents / totalStudents * 100).round()}%',
                    color: Colors.green,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: absentStudents.toDouble(),
                    title: '${(absentStudents / totalStudents * 100).round()}%',
                    color: Colors.red,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: lateStudents.toDouble(),
                    title: '${(lateStudents / totalStudents * 100).round()}%',
                    color: Colors.orange,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPieChartLegend('Present', Colors.green, presentStudents),
              _buildPieChartLegend('Absent', Colors.red, absentStudents),
              _buildPieChartLegend('Late', Colors.orange, lateStudents),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartLegend(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontSize: 12,
          ),
        ),
        Text(
          count.toString(),
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}