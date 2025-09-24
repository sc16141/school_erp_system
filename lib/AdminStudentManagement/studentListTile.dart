import 'package:flutter/material.dart';
import 'package:school/AdminStudentManagement/studentDetailsPage.dart';
import 'package:school/AdminStudentManagement/studentModel.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';

class StudentListPage extends StatefulWidget {
  final String selectedClass;

  const StudentListPage({Key? key, required this.selectedClass}) : super(key: key);

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Student> allStudents = [
    Student(
      id: 'STU001',
      name: 'Alice Johnson',
      email: 'alice.johnson@email.com',
      phone: '+1234567890',
      className: 'Class 1',
      admissionStatus: 'Active',
      dateOfBirth: DateTime(2017, 5, 15),
      address: '123 Maple Street, City',
    ),
    Student(
      id: 'STU002',
      name: 'Bob Smith',
      email: 'bob.smith@email.com',
      phone: '+1234567891',
      className: 'Class 1',
      admissionStatus: 'Active',
      dateOfBirth: DateTime(2017, 8, 22),
      address: '456 Oak Avenue, City',
    ),
    Student(
      id: 'STU003',
      name: 'Charlie Brown',
      email: 'charlie.brown@email.com',
      phone: '+1234567892',
      className: 'Class 2',
      admissionStatus: 'Active',
      dateOfBirth: DateTime(2016, 12, 10),
      address: '789 Pine Road, City',
    ),
    Student(
      id: 'STU004',
      name: 'Diana Prince',
      email: 'diana.prince@email.com',
      phone: '+1234567893',
      className: 'Class 2',
      admissionStatus: 'Pending',
      dateOfBirth: DateTime(2016, 3, 25),
      address: '321 Elm Street, City',
    ),
    Student(
      id: 'STU005',
      name: 'Edward Norton',
      email: 'edward.norton@email.com',
      phone: '+1234567894',
      className: 'Class 3',
      admissionStatus: 'Active',
      dateOfBirth: DateTime(2015, 7, 18),
      address: '654 Cedar Lane, City',
    ),
    // Add more students as needed...
  ];

  List<Student> students = [];
  List<Student> filteredStudents = [];
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    students = allStudents.where((student) => student.className == widget.selectedClass).toList();
    filteredStudents = students;
    searchController.addListener(_filterStudents);
  }

  void _filterStudents() {
    setState(() {
      filteredStudents = students.where((student) {
        bool matchesSearch = student.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
            student.id.toLowerCase().contains(searchController.text.toLowerCase()) ||
            student.email.toLowerCase().contains(searchController.text.toLowerCase());

        bool matchesFilter = selectedFilter == 'All' ||
            (selectedFilter == 'Active' && student.admissionStatus == 'Active') ||
            (selectedFilter == 'Pending' && student.admissionStatus == 'Pending') ||
            (selectedFilter == 'Inactive' && student.admissionStatus == 'Inactive');

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _navigateToStudentDetails(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsPage(student: student),
      ),
    );
  }

  void _addStudent() {
    _showStudentDialog();
  }

  void _editStudent(Student student) {
    _showStudentDialog(student: student);
  }

  void _removeStudent(String studentId) {
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
            'Are you sure you want to remove this student?',
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
                    students.removeWhere((s) => s.id == studentId);
                    allStudents.removeWhere((s) => s.id == studentId);
                    _filterStudents();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Student removed successfully!'),
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

  void _showStudentDialog({Student? student}) {
    final isEditing = student != null;
    final nameController = TextEditingController(text: student?.name ?? '');
    final emailController = TextEditingController(text: student?.email ?? '');
    final phoneController = TextEditingController(text: student?.phone ?? '');
    final addressController = TextEditingController(text: student?.address ?? '');
    String selectedStatus = student?.admissionStatus ?? 'Active';
    DateTime selectedDate = student?.dateOfBirth ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              ),
              title: Text(
                isEditing ? 'Edit Student' : 'Add New Student',
                style: AppThemeResponsiveness.getHeadingStyle(context),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(context, 'Name', nameController, Icons.person),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    _buildTextField(context, 'Email', emailController, Icons.email),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    _buildTextField(context, 'Phone', phoneController, Icons.phone),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    _buildTextField(context, 'Address', addressController, Icons.location_on),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                          vertical: AppThemeResponsiveness.getMediumSpacing(context),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey.shade600,
                              size: AppThemeResponsiveness.getIconSize(context),
                            ),
                            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                            Text(
                              'Date of Birth: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: AppThemeResponsiveness.getBodyTextStyle(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      style: AppThemeResponsiveness.getBodyTextStyle(context),
                      decoration: InputDecoration(
                        labelText: 'Admission Status',
                        labelStyle: AppThemeResponsiveness.getInputLabelStyle(context),
                        prefixIcon: Icon(
                          Icons.verified_user,
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
                      items: ['Active', 'Pending', 'Inactive'].map((status) {
                        return DropdownMenuItem(value: status, child: Text(status));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedStatus = value!;
                        });
                      },
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
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          phoneController.text.isNotEmpty) {
                        final newStudent = Student(
                          id: isEditing ? student!.id : 'STU${(allStudents.length + 1).toString().padLeft(3, '0')}',
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          className: widget.selectedClass,
                          admissionStatus: selectedStatus,
                          dateOfBirth: selectedDate,
                          address: addressController.text,
                        );

                        setState(() {
                          if (isEditing) {
                            int index = students.indexWhere((s) => s.id == student!.id);
                            int allIndex = allStudents.indexWhere((s) => s.id == student!.id);
                            students[index] = newStudent;
                            allStudents[allIndex] = newStudent;
                          } else {
                            students.add(newStudent);
                            allStudents.add(newStudent);
                          }
                          _filterStudents();
                        });
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEditing ? 'Student updated successfully!' : 'Student added successfully!'),
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
      },
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: AppThemeResponsiveness.getBodyTextStyle(context),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppThemeResponsiveness.getInputLabelStyle(context),
        prefixIcon: Icon(
          icon,
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
                        // Search and Filter Section
                        _buildSearchAndFilterSection(context),

                        // Students Header
                        _buildStudentsHeader(context),

                        // Students List/Grid
                        Expanded(
                          child: _buildStudentsList(context),
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
              Icons.group,
              color: AppThemeColor.white,
              size: AppThemeResponsiveness.getHeaderIconSize(context),
            ),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Flexible(
              child: Text(
                '${widget.selectedClass} Students',
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

  Widget _buildSearchAndFilterSection(BuildContext context) {
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
      child: Column(
        children: [
          TextField(
            controller: searchController,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
            decoration: InputDecoration(
              hintText: 'Search by name, ID, or email',
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
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Row(
            children: [
              Text(
                'Filter by status: ',
                style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,
                  underline: Container(),
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                  items: ['All', 'Active', 'Pending', 'Inactive'].map((filter) {
                    return DropdownMenuItem(value: filter, child: Text(filter));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                      _filterStudents();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
        vertical: AppThemeResponsiveness.getMediumSpacing(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Students (${filteredStudents.length})',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: AppThemeColor.primaryBlue,
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(
                context,
                AppThemeResponsiveness.getHeadingStyle(context).fontSize! + 4,
              ),
            ),
          ),
          Icon(
            Icons.group,
            color: AppThemeColor.primaryBlue,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(BuildContext context) {
    if (filteredStudents.isEmpty) {
      return _buildEmptyState(context);
    }

    return AppThemeResponsiveness.isDesktop(context) || AppThemeResponsiveness.isTablet(context)
        ? _buildStudentsGrid(context)
        : _buildStudentsListView(context);
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
            'No students found',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Try adjusting your search terms or filters',
            style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppThemeResponsiveness.getGridCrossAxisCount(context),
        crossAxisSpacing: AppThemeResponsiveness.getDashboardGridCrossAxisSpacing(context),
        mainAxisSpacing: AppThemeResponsiveness.getDashboardGridMainAxisSpacing(context),
        childAspectRatio: AppThemeResponsiveness.getGridChildAspectRatio(context) * 0.75,
      ),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return _buildStudentGridCard(context, filteredStudents[index]);
      },
    );
  }

  Widget _buildStudentsListView(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        return _buildStudentCard(context, filteredStudents[index]);
      },
    );
  }

  Widget _buildStudentGridCard(BuildContext context, Student student) {
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
        onTap: () => _navigateToStudentDetails(student),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        child: Padding(
          padding: EdgeInsets.all(AppThemeResponsiveness.getGridItemPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: AppThemeColor.white.withOpacity(0.2),
                    radius: AppThemeResponsiveness.getGridItemPadding(context),
                    child: Text(
                      student.name.substring(0, 1).toUpperCase(),
                      style: AppThemeResponsiveness.getGridItemTitleStyle(context).copyWith(
                        color: AppThemeColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStudentPopupMenu(context, student),
                ],
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                student.name,
                style: AppThemeResponsiveness.getGridItemTitleStyle(context).copyWith(
                  color: AppThemeColor.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              Text(
                'ID: ${student.id}',
                style: AppThemeResponsiveness.getGridItemSubtitleStyle(context).copyWith(
                  color: AppThemeColor.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(student.admissionStatus).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _getStatusColor(student.admissionStatus).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  student.admissionStatus,
                  style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                    color: _getStatusColor(student.admissionStatus),
                    fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
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

  Widget _buildStudentCard(BuildContext context, Student student) {
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
    leading: CircleAvatar(
    backgroundColor: AppThemeColor.white.withOpacity(0.2),
    radius: AppThemeResponsiveness.getDashboardCardIconSize(context) / 2,
    child: Text(
    student.name.substring(0, 1).toUpperCase(),
    style: AppThemeResponsiveness.getDashboardCardTitleStyle(context).copyWith(
    color: AppThemeColor.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    title: Text(
    student.name,
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
    'ID: ${student.id}',
    style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
    color: AppThemeColor.white.withOpacity(0.9),
    ),
    ),
    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
    Text(
    'Email: ${student.email}',
    style: AppThemeResponsiveness.getDashboardCardSubtitleStyle(context).copyWith(
    color: AppThemeColor.white.withOpacity(0.9),
    ),
    ),
    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
    Row(
    children: [
    Text(
    'Status: ',
    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
    color: AppThemeColor.white.withOpacity(0.8),
    ),
    ),
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getSmallSpacing(context),
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: _getStatusColor(student.admissionStatus),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          student.admissionStatus,
          style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
            color: AppThemeColor.white,
            fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
    ),
    ],
    ),
      trailing: _buildStudentPopupMenu(context, student),
      onTap: () => _navigateToStudentDetails(student),
    ),
    );
  }

  Widget _buildStudentPopupMenu(BuildContext context, Student student) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppThemeColor.white,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      color: AppThemeColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      onSelected: (value) {
        switch (value) {
          case 'view':
            _navigateToStudentDetails(student);
            break;
          case 'edit':
            _editStudent(student);
            break;
          case 'delete':
            _removeStudent(student.id);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'view',
          child: Row(
            children: [
              Icon(
                Icons.visibility,
                color: AppThemeColor.primaryBlue,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'View Details',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: Colors.orange,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Edit Student',
                style: AppThemeResponsiveness.getBodyTextStyle(context),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red,
                size: AppThemeResponsiveness.getIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Delete Student',
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
      onPressed: _addStudent,
      backgroundColor: AppThemeColor.primaryBlue,
      foregroundColor: AppThemeColor.white,
      elevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
      ),
      icon: Icon(
        Icons.add,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      label: Text(
        'Add Student',
        style: AppThemeResponsiveness.getButtonTextStyle(context),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}