import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/commonImportsDashboard.dart';
import 'package:school/customWidgets/dashboardCustomWidgets/dashboardQuickAction.dart';
import 'package:school/model/quickActionModel.dart';
import 'package:school/model/adminProfileModel.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin{

  // Add admin profile data
  AdminProfile? adminData;
  PlatformFile? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  // Load admin data (replace with your actual data loading logic)
  void _loadAdminData() async {
    // Simulate loading admin data
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      adminData = AdminProfile(
        name: 'Mr. Rajesh Kumar Sharma',
        email: 'admin@royalpublic.edu',
        phone: '+91 98765 43210',
        adminId: 'ADM001',
        role: 'System Administrator',
        designation: 'Principal Administrator',
        experience: '15 years',
        qualification: 'M.B.A (Education Management), B.Ed',
        address: '123 Administrative Block, Royal Public School, Mumbai, Maharashtra',
        joinDate: 'March 15, 2009',
        permissions: ['Full System Access', 'User Management', 'Academic Oversight', 'Financial Control', 'Reports Generation'],
        managedSections: ['Academic Affairs', 'Student Management', 'Faculty Management', 'Finance', 'Infrastructure'],
        totalUsers: 1250,
        activeStudents: 875,
        totalFaculty: 95,
        totalStaff: 45,
        systemUptime: '99.8%',
        profileImageUrl: '', // Add actual profile image URL if available
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      drawer: _buildDrawer(),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppThemeColor.primaryGradient,
              ),
              child: SafeArea(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                    vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),
                      _buildQuickStatsSection(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.6),
                      SectionTitle(title: 'Quick Access'),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                      _buildDashboardGrid(context),
                      SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context) * 1.2),
                      SectionTitle(title: 'System Overview'),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                      _buildRecentActivity(),
                    ],
                  ),
                ),
              ),
            ),
            ExpandableFab(),
          ]
      ),
    );
  }

  Widget _buildDrawer(){
    return ModernDrawer(
      headerIcon: Icons.admin_panel_settings_rounded,
      headerTitle: adminData?.name ?? 'Administrator',
      headerSubtitle: adminData?.designation ?? 'Full System Control',
      sections: [
        ModernDrawerSection(
          title: 'Main',
          items: [
            ModernDrawerItem(
              icon: Icons.dashboard_rounded,
              title: 'Dashboard',
              route: '/admin-dashboard',
            ),
            ModernDrawerItem(
              icon: Icons.people_rounded,
              title: 'Student Management',
              route: '/admin-student-management',
            ),
            ModernDrawerItem(
              icon: Icons.work_rounded,
              title: 'Employee Management',
              route: '/admin-employee-management',
            ),
            ModernDrawerItem(
              icon: Icons.class_rounded,
              title: 'Class Management',
              route: '/admin-class-section-management',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Academic',
          items: [
            ModernDrawerItem(
              icon: Icons.grade_rounded,
              title: 'Academic Results',
              route: '/admin-academic-result-screen',
            ),
            ModernDrawerItem(
              icon: Icons.payment_rounded,
              title: 'Fee Management',
              route: '/admin-fee-management',
            ),
            ModernDrawerItem(
              icon: Icons.analytics_rounded,
              title: 'Reports & Analytics',
              route: '/admin-report-analytics',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Administration',
          items: [
            ModernDrawerItem(
              icon: Icons.person_add_alt_rounded,
              title: 'Add Applicant',
              route: '/admin-add-student-applicant',
            ),
            ModernDrawerItem(
              icon: Icons.add_rounded,
              title: 'Add Teacher',
              route: '/admin-add-teacher',
            ),
            ModernDrawerItem(
              icon: Icons.add_task,
              title: 'Add Designation',
              route: '/admin-add-designation',
            ),
            ModernDrawerItem(
              icon: Icons.notification_add_rounded,
              title: 'User Requests',
              route: '/admin-user-request',
              badge: '5',
            ),
            ModernDrawerItem(
              icon: Icons.settings_rounded,
              title: 'System Controls',
              route: '/admin-system-control',
            ),
          ],
        ),
        ModernDrawerSection(
          title: 'Settings',
          items: [
            ModernDrawerItem(
              icon: Icons.person_rounded,
              title: 'My Profile',
              route: '/admin-profile',
            ),
            ModernDrawerItem(
              icon: Icons.lock_rounded,
              title: 'Change Password',
              route: '/change-password',
            ),
            ModernDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: () => LogoutDialog.show(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(){
    if (adminData == null) {
      return Container(); // Return empty container if data is not loaded
    }

    return WelcomeSection(
      name: adminData!.name,
      classInfo: adminData!.designation,
      isActive: true,
      isVerified: true,
      isSuperUser: true,
      icon: Icons.admin_panel_settings_rounded,
      // profileImageUrl: adminData!.profileImageUrl,
      // profileImageFile: _profileImage,
    );
  }

  Widget _buildQuickStatsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickStatCard(
            title: 'Total Students',
            value: adminData?.totalUsers.toString() ?? '1,245',
            icon: Icons.people_rounded,
            iconColor: Colors.blue,
            iconBackgroundColor: Colors.blue.shade50,
            onTap: () => Navigator.pushNamed(context, '/admin-student-management'),
          ),
          QuickStatCard(
            title: 'Total Employee',
            value: adminData?.totalFaculty.toString() ?? '67',
            icon: Icons.school_rounded,
            iconColor: Colors.green,
            iconBackgroundColor: Colors.green.shade50,
            onTap: () => Navigator.pushNamed(context, '/admin-employee-management'),
          ),
          QuickStatCard(
            title: 'Pending Admissions',
            value: '23',
            icon: Icons.pending_rounded,
            iconColor: Colors.orange,
            iconBackgroundColor: Colors.orange.shade50,
            onTap: () => Navigator.pushNamed(context, '/admin-pending-admission'),
          ),
          QuickStatCard(
            title: 'Attendance Report',
            value: 'All',
            icon: Icons.bar_chart_outlined,
            iconColor: Colors.purple,
            iconBackgroundColor: Colors.purple.shade50,
            onTap: () => Navigator.pushNamed(context, '/academic-officer-attendance-reports'),
          ),
          QuickStatCard(
            title: 'Active Notices',
            value: '5',
            icon: Icons.notifications_active_rounded,
            iconColor: Colors.red,
            iconBackgroundColor: Colors.red.shade50,
            onTap: () => Navigator.pushNamed(context, '/academic-officer-notification'),
          ),
          QuickStatCard(
            title: 'System Health',
            value: adminData?.systemUptime ?? '98%',
            icon: Icons.health_and_safety_rounded,
            iconColor: Colors.teal,
            iconBackgroundColor: Colors.teal.shade50,
            onTap: () => Navigator.pushNamed(context, '/admin-system-health'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    final items = [
      DashboardItem(
        'Student Management',
        Icons.people_rounded,
        Colors.blue,
            () => Navigator.pushNamed(context, '/admin-student-management'),
        'Manage student records & data',
      ),
      DashboardItem(
        'Employee Management',
        Icons.work_rounded,
        Colors.green,
            () => Navigator.pushNamed(context, '/admin-employee-management'),
        'Staff records & management',
      ),
      DashboardItem(
        'Class Management',
        Icons.class_rounded,
        Colors.orange,
            () => Navigator.pushNamed(context, '/admin-class-section-management'),
        'Classes & sections setup',
      ),
      DashboardItem(
        'Fee Management',
        Icons.payment_rounded,
        Colors.purple,
            () => Navigator.pushNamed(context, '/admin-fee-management'),
        'Fee collection & tracking',
      ),
      DashboardItem(
        'Fee Structure Management',
        Icons.payment_rounded,
        Colors.blueGrey,
            () => Navigator.pushNamed(context, '/admin-fee-structure'),
        'Adding fess',
      ),
      DashboardItem(
        'Salary Management',
        Icons.payment_rounded,
        Colors.yellow,
            () => Navigator.pushNamed(context, '/admin-salary-management'),
        'Fee collection & tracking',
      ),
      DashboardItem(
        'Reports & Analytics',
        Icons.analytics_rounded,
        Colors.teal,
            () => Navigator.pushNamed(context, '/admin-report-analytics'),
        'Data insights & reports',
      ),
      DashboardItem(
        'Add New Applicant',
        Icons.person_add_alt_rounded,
        Colors.brown,
            () => Navigator.pushNamed(context, '/admin-add-student-applicant'),
        'New student applications',
      ),
      DashboardItem(
        'Add Teacher',
        Icons.add_rounded,
        Colors.green,
            () => Navigator.pushNamed(context, '/admin-add-teacher'),
        'Register new teaching staff',
      ),
      DashboardItem(
        'Add Designation',
        Icons.add_task,
        Colors.deepOrangeAccent,
            () => Navigator.pushNamed(context, '/admin-add-designation'),
        'Register new teaching staff',
      ),
      DashboardItem(
        'User Requests',
        Icons.notification_add_rounded,
        Colors.deepPurple,
            () => Navigator.pushNamed(context, '/admin-user-request'),
        'Handle user requests',
        badge: '5',
      ),
      DashboardItem(
        'System Controls',
        Icons.settings_rounded,
        Colors.red.shade700,
            () => Navigator.pushNamed(context, '/admin-system-control'),
        'System configuration',
      ),
      DashboardItem(
        'Academic Options',
        Icons.sports_rounded,
        Colors.black45,
            () => Navigator.pushNamed(context, '/academic-options'),
        'Academic year & settings',
      ),
      DashboardItem(
        'Add Time Table',
        Icons.add_alarm_outlined,
        Colors.indigo,
            () => Navigator.pushNamed(context, '/admin-add-timetable'),
        'Academic year & settings',
      ),
      DashboardItem(
        'View Document',
        Icons.document_scanner,
        Colors.pink,
            () => Navigator.pushNamed(context, '/admin-document-submitted'),
        'Documents submitted',
      ),
      DashboardItem(
        'Profile',
        Icons.person,
        Colors.teal,
            () => Navigator.pushNamed(context, '/admin-profile'),
        'About Me',
      ),
      DashboardItem(
        'Quick Actions',
        Icons.flash_on_rounded,
        Colors.amber.shade700,
            () => _showQuickActionsDialog(context),
        'Shortcuts & quick tasks',
      ),
    ];

    return DashboardGrid(items: items);
  }

  void _showQuickActionsDialog(BuildContext context){
    return QuickActionsDialog.show(
      context,
      actions: [
        QuickActionItem(
          icon: Icons.person_add_rounded,
          color: Colors.blue,
          title: 'Add New Student',
          subtitle: 'Enroll new students quickly',
          route: '/admin-add-student-applicant',
        ),
        QuickActionItem(
          icon: Icons.work_outline_rounded,
          color: Colors.green,
          title: 'Add New Employee',
          subtitle: 'Register new staff members',
          route: '/admin-add-teacher',
        ),
        QuickActionItem(
          icon: Icons.announcement_rounded,
          color: Colors.orange,
          title: 'Add New Designation',
          subtitle: 'Register new position',
          route: '/admin-add-designation',
        ),
      ],
    );
  }

  Widget _buildRecentActivity(){
    return  RecentActivityCard(
      items: const [
        ActivityItem(
          icon: Icons.trending_up_rounded,
          title: 'System Performance: Excellent',
          time: '99.8% uptime',
          color: Colors.green,
        ),
        ActivityItem(
          icon: Icons.storage_rounded,
          title: 'Database Status: Healthy',
          time: 'Last backup: 2 hours ago',
          color: Colors.blue,
        ),
        ActivityItem(
          icon: Icons.security_rounded,
          title: 'Security: All systems secure',
          time: 'No threats detected',
          color: Colors.purple,
        ),
      ],
    );
  }
}