import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

class AdminReportsAnalytics extends StatefulWidget {
  const AdminReportsAnalytics({Key? key}) : super(key: key);

  @override
  State<AdminReportsAnalytics> createState() => _AdminReportsAnalyticsState();
}

class _AdminReportsAnalyticsState extends State<AdminReportsAnalytics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _selectedTimeRange = 'This Month';
  String _selectedClass = 'All Classes';

  // Sample analytics data
  Map<String, dynamic> _analyticsData = {
    'overview': {
      'totalStudents': 1250,
      'totalTeachers': 85,
      'totalRevenue': 125000,
      'expenses': 95000,
      'profit': 30000,
      'attendanceRate': 89.5,
      'passRate': 94.2,
      'parentSatisfaction': 87.8,
    },
    'enrollment': {
      'newEnrollments': 45,
      'withdrawals': 8,
      'pendingApplications': 23,
      'monthlyTrend': [
        {'month': 'Jan', 'enrollments': 35, 'withdrawals': 5},
        {'month': 'Feb', 'enrollments': 42, 'withdrawals': 3},
        {'month': 'Mar', 'enrollments': 38, 'withdrawals': 7},
        {'month': 'Apr', 'enrollments': 45, 'withdrawals': 4},
        {'month': 'May', 'enrollments': 41, 'withdrawals': 6},
        {'month': 'Jun', 'enrollments': 48, 'withdrawals': 2},
      ],
    },
    'academic': {
      'classPerformance': [
        {'class': 'Grade 1', 'avgScore': 85, 'passRate': 95},
        {'class': 'Grade 2', 'avgScore': 82, 'passRate': 92},
        {'class': 'Grade 3', 'avgScore': 78, 'passRate': 89},
        {'class': 'Grade 4', 'avgScore': 80, 'passRate': 91},
        {'class': 'Grade 5', 'avgScore': 77, 'passRate': 87},
        {'class': 'Grade 6', 'avgScore': 75, 'passRate': 85},
      ],
      'subjectPerformance': [
        {'subject': 'Mathematics', 'avgScore': 78, 'improvement': 2.5},
        {'subject': 'Science', 'avgScore': 82, 'improvement': 1.8},
        {'subject': 'English', 'avgScore': 85, 'improvement': 3.2},
        {'subject': 'History', 'avgScore': 80, 'improvement': -0.5},
        {'subject': 'Geography', 'avgScore': 79, 'improvement': 1.2},
      ],
    },
    'financial': {
      'revenue': {
        'tuitionFees': 85000,
        'examFees': 15000,
        'otherFees': 25000,
      },
      'expenses': {
        'salaries': 60000,
        'utilities': 15000,
        'maintenance': 10000,
        'supplies': 8000,
        'others': 2000,
      },
      'monthlyRevenue': [
        {'month': 'Jan', 'revenue': 105000, 'expenses': 85000},
        {'month': 'Feb', 'revenue': 110000, 'expenses': 88000},
        {'month': 'Mar', 'revenue': 115000, 'expenses': 90000},
        {'month': 'Apr', 'revenue': 120000, 'expenses': 92000},
        {'month': 'May', 'revenue': 118000, 'expenses': 89000},
        {'month': 'Jun', 'revenue': 125000, 'expenses': 95000},
      ],
    },
    'teacher': {
      'performance': [
        {'name': 'John Smith', 'rating': 4.8, 'subjects': 'Mathematics'},
        {'name': 'Sarah Johnson', 'rating': 4.9, 'subjects': 'Science'},
        {'name': 'Mike Brown', 'rating': 4.6, 'subjects': 'English'},
        {'name': 'Emma Davis', 'rating': 4.7, 'subjects': 'History'},
        {'name': 'David Wilson', 'rating': 4.5, 'subjects': 'Geography'},
      ],
      'attendanceRate': 96.5,
      'avgRating': 4.7,
      'totalHours': 2840,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              : Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
                child: Column(
                  children: [
                    HeaderSection(
                      title: 'Reports & Analytics',
                      icon: Icons.analytics_outlined,
                    ),
                    SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                    _buildFilterSection(),
                  ],
                ),
              ),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildAcademicTab(),
                    _buildFinancialTab(),
                    _buildEnrollmentTab(),
                    _buildTeacherTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownFilter(
              'Time Range',
              _selectedTimeRange,
              ['This Week', 'This Month', 'This Quarter', 'This Year'],
                  (value) => setState(() => _selectedTimeRange = value!),
            ),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: _buildDropdownFilter(
              'Class',
              _selectedClass,
              ['All Classes', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'],
                  (value) => setState(() => _selectedClass = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getMediumSpacing(context),
              vertical: AppThemeResponsiveness.getSmallSpacing(context),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppThemeColor.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppThemeColor.primaryBlue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppThemeColor.primaryBlue,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Academic'),
          Tab(text: 'Financial'),
          Tab(text: 'Enrollment'),
          Tab(text: 'Teachers'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildOverviewStats(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildKPICards(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildOverviewChart(),
        ],
      ),
    );
  }

  Widget _buildOverviewStats() {
    final overview = _analyticsData['overview'] as Map<String, dynamic>;

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
            'School Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
            mainAxisSpacing: AppThemeResponsiveness.getMediumSpacing(context),
            children: [
              _buildOverviewCard('Total Students', overview['totalStudents'].toString(), Icons.school, Colors.blue),
              _buildOverviewCard('Total Teachers', overview['totalTeachers'].toString(), Icons.person, Colors.green),
              _buildOverviewCard('Attendance Rate', '${overview['attendanceRate']}%', Icons.check_circle, Colors.orange),
              _buildOverviewCard('Pass Rate', '${overview['passRate']}%', Icons.trending_up, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 200,
      ),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context)),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    final overview = _analyticsData['overview'] as Map<String, dynamic>;

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Revenue',
            '₹${overview['totalRevenue']}',
            '↑ 12.5%',
            Colors.green,
            Icons.attach_money,
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: _buildKPICard(
            'Net Profit',
            '₹${overview['profit']}',
            '↑ 8.3%',
            Colors.blue,
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String change, Color color, IconData icon) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
            ),
          ),
          Text(
            change,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewChart() {
    final financial = _analyticsData['financial'] as Map<String, dynamic>;
    final monthlyRevenue = financial['monthlyRevenue'] as List<dynamic>;

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
            'Revenue vs Expenses Trend',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyRevenue.length) {
                          return Text(
                            monthlyRevenue[value.toInt()]['month'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value / 1000).toInt()}k',
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
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
                    spots: monthlyRevenue.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['revenue'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
                  ),
                  LineChartBarData(
                    spots: monthlyRevenue.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['expenses'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Revenue', Colors.green),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildLegendItem('Expenses', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildClassPerformanceChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildSubjectPerformanceChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildAcademicSummary(),
        ],
      ),
    );
  }

  Widget _buildClassPerformanceChart() {
    final academic = _analyticsData['academic'] as Map<String, dynamic>;
    final classPerformance = academic['classPerformance'] as List<dynamic>;

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
            'Class Performance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < classPerformance.length) {
                          return Text(
                            classPerformance[value.toInt()]['class'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
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
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: classPerformance.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value['avgScore'].toDouble(),
                        color: AppThemeColor.primaryBlue,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformanceChart() {
    final academic = _analyticsData['academic'] as Map<String, dynamic>;
    final subjectPerformance = academic['subjectPerformance'] as List<dynamic>;

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
            'Subject Performance & Improvement',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjectPerformance.length,
            itemBuilder: (context, index) {
              final subject = subjectPerformance[index];
              final improvement = subject['improvement'] as double;
              final isPositive = improvement > 0;

              return Container(
                margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
                padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        subject['subject'],
                        style: AppThemeResponsiveness.getBodyTextStyle(context),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${subject['avgScore']}%',
                        style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            isPositive ? Icons.trending_up : Icons.trending_down,
                            color: isPositive ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${improvement.abs()}%',
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              color: isPositive ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicSummary() {
    final overview = _analyticsData['overview'] as Map<String, dynamic>;

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
            'Academic Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem('Overall Pass Rate', '${overview['passRate']}%', Colors.green),
              _buildSummaryItem('Attendance Rate', '${overview['attendanceRate']}%', Colors.blue),
              _buildSummaryItem('Parent Satisfaction', '${overview['parentSatisfaction']}%', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            fontSize: 24,
            color: color,
          ),
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
        Text(
          title,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildRevenueExpenseChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildFinancialBreakdown(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildFinancialSummary(),
        ],
      ),
    );
  }

  Widget _buildRevenueExpenseChart() {
    final financial = _analyticsData['financial'] as Map<String, dynamic>;
    final revenue = financial['revenue'] as Map<String, dynamic>;
    final expenses = financial['expenses'] as Map<String, dynamic>;

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
            'Revenue vs Expenses Breakdown',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Sources',
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: revenue['tuitionFees'].toDouble(),
                              title: '${(revenue['tuitionFees'] / (revenue['tuitionFees'] + revenue['examFees'] + revenue['otherFees']) * 100).round()}%',
                              color: Colors.blue,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: revenue['examFees'].toDouble(),
                              title: '${(revenue['examFees'] / (revenue['tuitionFees'] + revenue['examFees'] + revenue['otherFees']) * 100).round()}%',
                              color: Colors.green,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: revenue['otherFees'].toDouble(),
                              title: '${(revenue['otherFees'] / (revenue['tuitionFees'] + revenue['examFees'] + revenue['otherFees']) * 100).round()}%',
                              color: Colors.orange,
                              radius: 50,
                            ),
                          ],
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Categories',
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: expenses['salaries'].toDouble(),
                              title: '${(expenses['salaries'] / (expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others']) * 100).round()}%',
                              color: Colors.red,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: expenses['utilities'].toDouble(),
                              title: '${(expenses['utilities'] / (expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others']) * 100).round()}%',
                              color: Colors.purple,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: expenses['maintenance'].toDouble(),
                              title: '${(expenses['maintenance'] / (expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others']) * 100).round()}%',
                              color: Colors.teal,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: expenses['supplies'].toDouble(),
                              title: '${(expenses['supplies'] / (expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others']) * 100).round()}%',
                              color: Colors.amber,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: expenses['others'].toDouble(),
                              title: '${(expenses['others'] / (expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others']) * 100).round()}%',
                              color: Colors.grey,
                              radius: 50,
                            ),
                          ],
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdown() {
    final financial = _analyticsData['financial'] as Map<String, dynamic>;
    final revenue = financial['revenue'] as Map<String, dynamic>;
    final expenses = financial['expenses'] as Map<String, dynamic>;

    return Column(
      children: [
        Container(
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
                  'Revenue Breakdown',
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                _buildFinancialItem('Tuition Fees', revenue['tuitionFees'], Colors.blue),
                _buildFinancialItem('Exam Fees', revenue['examFees'], Colors.green),
                _buildFinancialItem('Other Fees', revenue['otherFees'], Colors.orange),
                Divider(),
                _buildFinancialItem('Total Revenue', revenue['tuitionFees'] + revenue['examFees'] + revenue['otherFees'], Colors.black, isTotal: true),
              ],
            ),
          ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
    Container(
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
                  'Expense Breakdown',
                  style: AppThemeResponsiveness.getHeadingStyle(context),
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                _buildFinancialItem('Salaries', expenses['salaries'], Colors.red),
                _buildFinancialItem('Utilities', expenses['utilities'], Colors.purple),
                _buildFinancialItem('Maintenance', expenses['maintenance'], Colors.teal),
                _buildFinancialItem('Supplies', expenses['supplies'], Colors.amber),
                _buildFinancialItem('Others', expenses['others'], Colors.grey),
                Divider(),
                _buildFinancialItem('Total Expenses', expenses['salaries'] + expenses['utilities'] + expenses['maintenance'] + expenses['supplies'] + expenses['others'], Colors.black, isTotal: true),
              ],
            ),
          ),

      ],
    );
  }

  Widget _buildFinancialItem(String title, int amount, Color color, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isTotal) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              ],
              Text(
                title,
                style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            '₹${amount.toString()}',
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    final overview = _analyticsData['overview'] as Map<String, dynamic>;

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
            'Financial Summary',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem('Total Revenue', '₹${overview['totalRevenue']}', Colors.green),
              _buildSummaryItem('Total Expenses', '₹${overview['expenses']}', Colors.red),
              _buildSummaryItem('Net Profit', '₹${overview['profit']}', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildEnrollmentOverview(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildEnrollmentTrendChart(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildEnrollmentStats(),
        ],
      ),
    );
  }

  Widget _buildEnrollmentOverview() {
    final enrollment = _analyticsData['enrollment'] as Map<String, dynamic>;

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
            'Enrollment Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildEnrollmentCard(
                  'New Enrollments',
                  enrollment['newEnrollments'].toString(),
                  Icons.person_add,
                  Colors.green,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildEnrollmentCard(
                  'Withdrawals',
                  enrollment['withdrawals'].toString(),
                  Icons.person_remove,
                  Colors.red,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildEnrollmentCard(
                  'Pending Applications',
                  enrollment['pendingApplications'].toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(String title, String value, IconData icon, Color color) {
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
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 20),
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentTrendChart() {
    final enrollment = _analyticsData['enrollment'] as Map<String, dynamic>;
    final monthlyTrend = enrollment['monthlyTrend'] as List<dynamic>;

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
            'Enrollment Trend',
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
                        if (value.toInt() < monthlyTrend.length) {
                          return Text(
                            monthlyTrend[value.toInt()]['month'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(fontSize: 10),
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
                    spots: monthlyTrend.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['enrollments'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
                  ),
                  LineChartBarData(
                    spots: monthlyTrend.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['withdrawals'].toDouble());
                    }).toList(),
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: true, color: Colors.red.withOpacity(0.1)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Enrollments', Colors.green),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              _buildLegendItem('Withdrawals', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentStats() {
    final enrollment = _analyticsData['enrollment'] as Map<String, dynamic>;
    final netEnrollment = enrollment['newEnrollments'] - enrollment['withdrawals'];

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
            'Enrollment Statistics',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem('Net Enrollment', '+$netEnrollment', Colors.blue),
              _buildSummaryItem('Retention Rate', '94%', Colors.green),
              _buildSummaryItem('Conversion Rate', '78%', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      child: Column(
        children: [
          _buildTeacherOverview(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildTeacherPerformanceList(),
          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
          _buildTeacherStats(),
        ],
      ),
    );
  }

  Widget _buildTeacherOverview() {
    final teacher = _analyticsData['teacher'] as Map<String, dynamic>;

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
            'Teacher Overview',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            children: [
              Expanded(
                child: _buildTeacherCard(
                  'Attendance Rate',
                  '${teacher['attendanceRate']}%',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildTeacherCard(
                  'Average Rating',
                  '${teacher['avgRating']}/5',
                  Icons.star,
                  Colors.orange,
                ),
              ),
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Expanded(
                child: _buildTeacherCard(
                  'Total Hours',
                  '${teacher['totalHours']}h',
                  Icons.schedule,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(String title, String value, IconData icon, Color color) {
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
          Text(
            value,
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18),
              color: color,
            ),
          ),
          Text(
            title,
            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherPerformanceList() {
    final teacher = _analyticsData['teacher'] as Map<String, dynamic>;
    final performance = teacher['performance'] as List<dynamic>;

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
            'Teacher Performance',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: performance.length,
            itemBuilder: (context, index) {
              final teacherData = performance[index];
              final rating = teacherData['rating'] as double;

              return Container(
                margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
                padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppThemeColor.primaryBlue,
                      child: Text(
                        teacherData['name'].split(' ').map((n) => n[0]).join(''),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teacherData['name'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            teacherData['subjects'],
                            style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherStats() {
    final overview = _analyticsData['overview'] as Map<String, dynamic>;
    final teacher = _analyticsData['teacher'] as Map<String, dynamic>;

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
            'Teacher Statistics',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem('Total Teachers', '${overview['totalTeachers']}', Colors.blue),
              _buildSummaryItem('Avg Rating', '${teacher['avgRating']}/5', Colors.orange),
              _buildSummaryItem('Attendance', '${teacher['attendanceRate']}%', Colors.green),
            ],
          ),
        ],
      ),
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
}