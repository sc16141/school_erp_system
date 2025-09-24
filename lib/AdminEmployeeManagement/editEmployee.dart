import 'package:flutter/material.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/commonCustomWidget/themeColor.dart';
import 'package:school/customWidgets/commonCustomWidget/themeResponsiveness.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/model/dashboard/adminDashboardModel/employeeModel.dart';

// Add/Edit Teacher Page
class AddEditEmployeePage extends StatefulWidget {
  final Employee? employee;
  final int? employeeIndex;
  final String? employeeId;
  final Function(Employee) onSave;

  AddEditEmployeePage({
    this.employee,
    this.employeeIndex,
    this.employeeId,
    required this.onSave,
  });

  @override
  _AddEditEmployeePageState createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _departmentController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _employeeId;
  bool _isLoading = false;

  // Predefined subjects for school teachers
  final List<String> _subjects = [
    'Mathematics',
    'English',
    'Science',
    'Social Studies',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Physical Education',
    'Arts',
    'Music',
    'Hindi',
    'Geography',
    'History',
    'Economics',
    'Commerce',
    'Literature',
    'Environmental Science',
    'Psychology',
    'Philosophy',
    'Other'
  ];

  // Teacher roles/positions
  final List<String> _teacherRoles = [
    'Mathematics Teacher',
    'English Teacher',
    'Science Teacher',
    'Social Studies Teacher',
    'Physics Teacher',
    'Chemistry Teacher',
    'Biology Teacher',
    'Computer Science Teacher',
    'Physical Education Teacher',
    'Art Teacher',
    'Music Teacher',
    'Hindi Teacher',
    'Geography Teacher',
    'History Teacher',
    'Economics Teacher',
    'Commerce Teacher',
    'Literature Teacher',
    'Environmental Science Teacher',
    'Psychology Teacher',
    'Philosophy Teacher',
    'Head Teacher',
    'Vice Principal',
    'Department Head',
    'Special Education Teacher',
    'Librarian',
    'Counselor',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _employeeId = widget.employee?.id ?? widget.employeeId ?? '';
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _roleController = TextEditingController(text: widget.employee?.role ?? '');
    _departmentController = TextEditingController(text: widget.employee?.department ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.employee != null;

    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Responsive Header
              SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
              Padding(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Expanded(
                  child: Text(
                    isEditing ? 'Edit Teacher' : 'Add Teacher',
                    style: AppThemeResponsiveness.getFontStyle(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Responsive Form Container
              Expanded(
                child: Container(
                  width: AppThemeResponsiveness.getMaxWidth(context),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getMediumSpacing(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppThemeColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: AppThemeResponsiveness.getResponsivePadding(
                        context,
                        AppThemeResponsiveness.getDefaultSpacing(context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teacher ID Display Card
                          _buildEmployeeIdCard(),

                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                          // Name Field using AppTextFieldBuilder
                          AppTextFieldBuilder.build(
                            context: context,
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter teacher name';
                              }
                              if (value.length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                          // Role/Position Dropdown
                          _buildDropdownField(
                            controller: _roleController,
                            label: 'Role/Position',
                            icon: Icons.work,
                            items: _teacherRoles,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select teacher role';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                          // Subject/Department Dropdown
                          _buildDropdownField(
                            controller: _departmentController,
                            label: 'Subject/Department',
                            icon: Icons.school,
                            items: _subjects,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select subject/department';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                          // Phone Field using AppTextFieldBuilder
                          AppTextFieldBuilder.build(
                            context: context,
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              if (value.length < 10) {
                                return 'Phone number must be at least 10 digits';
                              }
                              if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                          // Email Field using AppTextFieldBuilder
                          AppTextFieldBuilder.build(
                            context: context,
                            controller: _emailController,
                            label: 'Email Address',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                          // Action Buttons
                          _buildActionButtons(isEditing),

                          // Add extra spacing for better scroll experience
                          SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                        ],
                      ),
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

  Widget _buildEmployeeIdCard() {
    return Container(
      width: double.infinity,
      padding: AppThemeResponsiveness.getResponsivePadding(
        context,
        AppThemeResponsiveness.getMediumSpacing(context),
      ),
      decoration: BoxDecoration(
        color: AppThemeColor.blue50,
        borderRadius: BorderRadius.circular(
          AppThemeResponsiveness.getInputBorderRadius(context),
        ),
        border: Border.all(color: AppThemeColor.blue200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teacher ID',
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 12.0),
              color: AppThemeColor.blue600,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            _employeeId.isEmpty ? 'Auto-generated' : _employeeId,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.getResponsiveFontSize(context, 18.0),
              fontWeight: FontWeight.bold,
              color: AppThemeColor.blue800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty && items.contains(controller.text)
          ? controller.text
          : null,
      validator: validator,
      style: AppThemeResponsiveness.getBodyTextStyle(context),
      dropdownColor: AppThemeColor.white,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppThemeColor.blue600,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          icon,
          size: AppThemeResponsiveness.getIconSize(context),
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(
            color: AppThemeColor.blue600,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppThemeResponsiveness.getInputBorderRadius(context),
          ),
          borderSide: BorderSide(color: Colors.red.shade600, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            controller.text = newValue;
          });
        }
      },
      isExpanded: true,
      menuMaxHeight: AppThemeResponsiveness.isMobile(context) ? 200 : 300,
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Column(
      children: [
        // Primary Save/Update Button
        PrimaryButton(
          title: isEditing ? 'Update Teacher' : 'Save Teacher',
          icon: Icon(
            isEditing ? Icons.update : Icons.save,
            color: Colors.white,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          onPressed: _saveEmployee,
          isLoading: _isLoading,
        ),

        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

        // Secondary Cancel Button
        SecondaryButton(
          title: 'Cancel',
          icon: Icon(
            Icons.cancel,
            color: Colors.grey[600],
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          color: Colors.grey[600]!,
          onPressed: _isLoading ? null : () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate processing delay
      await Future.delayed(Duration(milliseconds: 500));

      final employee = Employee(
        id: _employeeId.isEmpty ? _generateEmployeeId() : _employeeId,
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        department: _departmentController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
      );

      widget.onSave(employee);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);

      AppSnackBar.show(
        context,
        message:  widget.employee != null
            ? 'Teacher updated successfully!'
            : 'Teacher added successfully!',
        backgroundColor: Colors.green,
        icon: widget.employee != null ? Icons.check_circle : Icons.add_circle,
        action: SnackBarAction(
          label: 'OK',
          textColor: AppThemeColor.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
    }
  }

  String _generateEmployeeId() {
    // Generate a simple employee ID based on timestamp and random characters
    final now = DateTime.now();
    final timeStamp = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final random = (1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).round();
    return 'EMP$timeStamp$random';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}