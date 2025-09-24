import 'package:flutter/material.dart';
import 'package:school/AdminStudentManagement/studentListTile.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/model/dashboard/classInfo.dart';

class ClassManagementPage extends StatefulWidget {
  @override
  _ClassManagementPageState createState() => _ClassManagementPageState();
}

class _ClassManagementPageState extends State<ClassManagementPage> {
  List<ClassInfo> classes = [
    ClassInfo(
      id: 'CLS001',
      name: 'Class 1',
      teacher: 'Mrs. Anderson',
      totalStudents: 25,
      description: 'Primary level - Foundation learning',
    ),
    ClassInfo(
      id: 'CLS002',
      name: 'Class 2',
      teacher: 'Mr. Johnson',
      totalStudents: 28,
      description: 'Primary level - Basic concepts',
    ),
    ClassInfo(
      id: 'CLS003',
      name: 'Class 3',
      teacher: 'Ms. Williams',
      totalStudents: 30,
      description: 'Primary level - Core subjects',
    ),
    ClassInfo(
      id: 'CLS004',
      name: 'Class 4',
      teacher: 'Mrs. Brown',
      totalStudents: 27,
      description: 'Primary level - Advanced basics',
    ),
    ClassInfo(
      id: 'CLS005',
      name: 'Class 5',
      teacher: 'Mr. Davis',
      totalStudents: 32,
      description: 'Primary level - Intermediate',
    ),
    ClassInfo(
      id: 'CLS006',
      name: 'Class 6',
      teacher: 'Ms. Miller',
      totalStudents: 29,
      description: 'Middle school - Foundation',
    ),
    ClassInfo(
      id: 'CLS007',
      name: 'Class 7',
      teacher: 'Mr. Wilson',
      totalStudents: 31,
      description: 'Middle school - Core subjects',
    ),
    ClassInfo(
      id: 'CLS008',
      name: 'Class 8',
      teacher: 'Mrs. Moore',
      totalStudents: 26,
      description: 'Middle school - Advanced',
    ),
    ClassInfo(
      id: 'CLS009',
      name: 'Class 9',
      teacher: 'Mr. Taylor',
      totalStudents: 24,
      description: 'High school - Secondary',
    ),
    ClassInfo(
      id: 'CLS010',
      name: 'Class 10',
      teacher: 'Ms. Thomas',
      totalStudents: 22,
      description: 'High school - Board preparation',
    ),
    ClassInfo(
      id: 'CLS011',
      name: 'Class 11',
      teacher: 'Mr. Jackson',
      totalStudents: 20,
      description: 'Higher secondary - Stream selection',
    ),
    ClassInfo(
      id: 'CLS012',
      name: 'Class 12',
      teacher: 'Mrs. White',
      totalStudents: 18,
      description: 'Higher secondary - Final year',
    ),
  ];

  List<ClassInfo> filteredClasses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredClasses = classes;
    searchController.addListener(_filterClasses);
  }

  void _filterClasses() {
    setState(() {
      filteredClasses = classes.where((classInfo) {
        return classInfo.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            classInfo.teacher.toLowerCase().contains(searchController.text.toLowerCase()) ||
            classInfo.id.toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  void _navigateToStudentList(ClassInfo classInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentListPage(selectedClass: classInfo.name),
      ),
    );
  }

  void _addNewClass() {
    _showClassDialog();
  }

  void _editClass(ClassInfo classInfo) {
    _showClassDialog(classInfo: classInfo);
  }

  void _removeClass(String classId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          title: Text(
            'Confirm Delete',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: Text(
            'Are you sure you want to remove this class? This will also remove all students in this class.',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppThemeColor.primaryBlue,
                  fontSize: AppThemeResponsiveness.getButtonTextStyle(context).fontSize,
                ),
              ),
            ),
            SizedBox(
              height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    classes.removeWhere((c) => c.id == classId);
                    _filterClasses();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Class removed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: AppThemeResponsiveness.getButtonTextStyle(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClassDialog({ClassInfo? classInfo}) {
    final isEditing = classInfo != null;
    final nameController = TextEditingController(text: classInfo?.name ?? '');
    final teacherController = TextEditingController(text: classInfo?.teacher ?? '');
    final descriptionController = TextEditingController(text: classInfo?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          title: Text(
            isEditing ? 'Edit Class' : 'Add New Class',
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                  decoration: InputDecoration(
                    labelText: 'Class Name',
                    labelStyle: AppThemeResponsiveness.getInputLabelStyle(context),
                    prefixIcon: Icon(
                      Icons.class_,
                      size: AppThemeResponsiveness.getIconSize(context),
                      color: AppThemeColor.primaryBlue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      borderSide: BorderSide(
                        color: AppThemeColor.primaryBlue,
                        width: AppThemeResponsiveness.getFocusedBorderWidth(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                TextField(
                  controller: teacherController,
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                  decoration: InputDecoration(
                    labelText: 'Class Teacher',
                    labelStyle: AppThemeResponsiveness.getInputLabelStyle(context),
                    prefixIcon: Icon(
                      Icons.person,
                      size: AppThemeResponsiveness.getIconSize(context),
                      color: AppThemeColor.primaryBlue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      borderSide: BorderSide(
                        color: AppThemeColor.primaryBlue,
                        width: AppThemeResponsiveness.getFocusedBorderWidth(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: AppThemeResponsiveness.getInputLabelStyle(context),
                    prefixIcon: Icon(
                      Icons.description,
                      size: AppThemeResponsiveness.getIconSize(context),
                      color: AppThemeColor.primaryBlue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                      borderSide: BorderSide(
                        color: AppThemeColor.primaryBlue,
                        width: AppThemeResponsiveness.getFocusedBorderWidth(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppThemeColor.primaryBlue,
                  fontSize: AppThemeResponsiveness.getButtonTextStyle(context).fontSize,
                ),
              ),
            ),
            SizedBox(
              height: AppThemeResponsiveness.getButtonHeight(context) * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && teacherController.text.isNotEmpty) {
                    final newClass = ClassInfo(
                      id: isEditing ? classInfo!.id : 'CLS${(classes.length + 1).toString().padLeft(3, '0')}',
                      name: nameController.text,
                      teacher: teacherController.text,
                      totalStudents: isEditing ? classInfo!.totalStudents : 0,
                      description: descriptionController.text,
                    );

                    setState(() {
                      if (isEditing) {
                        int index = classes.indexWhere((c) => c.id == classInfo!.id);
                        classes[index] = newClass;
                      } else {
                        classes.add(newClass);
                      }
                      _filterClasses();
                    });
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing ? 'Class updated successfully!' : 'Class added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColor.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
                  ),
                ),
                child: Text(
                  isEditing ? 'Update' : 'Add',
                  style: AppThemeResponsiveness.getButtonTextStyle(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              bottom: AppThemeResponsiveness.getDashboardVerticalPadding(context),
              left: AppThemeResponsiveness.getSmallSpacing(context),
              right: AppThemeResponsiveness.getSmallSpacing(context),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: AppThemeResponsiveness.getMaxWidth(context),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      ),
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
                      children: [
                        // Search Section
                        _buildSearchSection(context),

                        // Classes Header
                        _buildClassesHeader(context),

                        // Classes List/Grid
                        Expanded(
                          child: _buildClassesList(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppThemeResponsiveness.getMaxWidth(context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDashboardHorizontalPadding(context),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppThemeResponsiveness.getDashboardVerticalPadding(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Flexible(
              child: Text(
                'Class Management',
                style: AppThemeResponsiveness.getSectionTitleStyle(context).copyWith(
                  fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                    context,
                    AppThemeResponsiveness.getSectionTitleStyle(context).fontSize! + 4,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      padding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: AppThemeResponsiveness.getBodyTextStyle(context),
        decoration: InputDecoration(
          hintText: 'Search by class no, teacher, or ID',
          hintStyle: AppThemeResponsiveness.getInputHintStyle(context),
          prefixIcon: Icon(
            Icons.search,
            color: AppThemeColor.primaryBlue,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppThemeColor.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
            vertical: AppThemeResponsiveness.getMediumSpacing(context),
          ),
        ),
      ),
    );
  }

  Widget _buildClassesHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Classes (${filteredClasses.length})',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: AppThemeColor.primaryBlue,
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                context,
                AppThemeResponsiveness.getHeadingStyle(context).fontSize! + 4,
              ),
            ),
          ),
          Icon(
            Icons.class_,
            color: AppThemeColor.primaryBlue,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesList(BuildContext context) {
    if (filteredClasses.isEmpty) {
      return _buildEmptyState(context);
    }

    return AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
        ? _buildClassesGrid(context)
        : _buildClassesListView(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: AppThemeResponsiveness.getEmptyStateIconSize(context),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            'No classes found',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Try adjusting your search terms',
            style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppThemeResponsiveness.getGridCrossAxisCount(context),
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: AppThemeResponsiveness.getGridChildAspectRatio(context) * 0.85,
      ),
      itemCount: filteredClasses.length,
      itemBuilder: (context, index) {
        return _buildClassGridCard(context, filteredClasses[index]);
      },
    );
  }

  Widget _buildClassesListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: filteredClasses.length,
      itemBuilder: (context, index) {
        return _buildClassCard(context, filteredClasses[index]);
      },
    );
  }

  Widget _buildClassGridCard(BuildContext context, ClassInfo classInfo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        gradient: LinearGradient(
          colors: [
            AppThemeColor.primaryBlue.withOpacity(0.8),
            AppThemeColor.primaryBlue.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToStudentList(classInfo),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getGridItemPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      classInfo.name,
                      style: AppThemeResponsiveness.getGridItemTitleStyle(context).copyWith(
                        color: AppThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildClassPopupMenu(context, classInfo),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Teacher: ${classInfo.teacher}',
                style: AppThemeResponsiveness.getGridItemSubtitleStyle(context).copyWith(
                  color: AppThemeColor.white.withOpacity(0.9),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              Text(
                'Students: ${classInfo.totalStudents}',
                style: AppThemeResponsiveness.getGridItemSubtitleStyle(context).copyWith(
                  color: AppThemeColor.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  classInfo.description,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: AppThemeColor.white.withOpacity(0.8),
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppThemeColor.white,
                  size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassInfo classInfo) {
    return Container(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getMediumSpacing(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        gradient: LinearGradient(
          colors: [
            AppThemeColor.primaryBlue.withOpacity(0.8),
            AppThemeColor.primaryBlue.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(AppThemeResponsiveness.getMediumSpacing(context)),
        leading: Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getDashboardCardIconPadding(context)),
          decoration: BoxDecoration(
            color: AppThemeColor.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          ),
          child: Icon(
            Icons.class_,
            color: AppThemeColor.white,
            size: AppThemeResponsiveness.getDashboardCardIconSize(context),
          ),
        ),
        title: Text(
          classInfo.name,
          style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
            color: AppThemeColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              'Teacher: ${classInfo.teacher}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
                color: AppThemeColor.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
            Text(
              'Students: ${classInfo.totalStudents}',
              style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
                color: AppThemeColor.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            Text(
              classInfo.description,
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: AppThemeColor.white.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildClassPopupMenu(context, classInfo),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Icon(
              Icons.arrow_forward_ios,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getIconSize(context) * 0.7,
            ),
          ],
        ),
        onTap: () => _navigateToStudentList(classInfo),
      ),
    );
  }

  Widget _buildClassPopupMenu(BuildContext context, ClassInfo classInfo) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppThemeColor.white,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          _editClass(classInfo);
        } else if (value == 'delete') {
          _removeClass(classInfo.id);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Edit',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
                size: AppThemeResponsiveness.getIconSize(context) * 0.8,
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Delete',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _addNewClass,
      backgroundColor: AppThemeColor.primaryBlue,
      foregroundColor: AppThemeColor.white,
      elevation: AppThemeResponsiveness.getButtonElevation(context),
      icon: Icon(
        Icons.add,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      label: Text(
        'Add Class',
        style: AppThemeResponsiveness.getButtonTextStyle(context).copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}