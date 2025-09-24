import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/customWidgets/AddCommonWidgets/addNewHeader.dart';
import 'package:school/customWidgets/AddCommonWidgets/addSectionHeader.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/commonImagePicker.dart';
import 'package:school/customWidgets/datePicker.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/button.dart';
import 'dart:io';

class AddTeacherScreen extends StatefulWidget {
  @override
  _AddTeacherScreenState createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _dobController = TextEditingController();
  final _designationController = TextEditingController();
  final _tagsController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  // Focus nodes for better UX
  final _nameFocus = FocusNode();
  final _teacherIdFocus = FocusNode();
  final _designationFocus = FocusNode();
  final _tagsFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _emailFocus = FocusNode();

  // Image related
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Loading state
  bool _isLoading = false;

  // Predefined designations for dropdown
  final List<String> _designations = [
    'Principal',
    'Vice Principal',
    'Head Teacher',
    'Senior Teacher',
    'Teacher',
    'Assistant Teacher',
    'Subject Coordinator',
    'Department Head',
    'Lab Assistant',
    'Physical Education Teacher',
    'Librarian',
    'Counselor'
  ];

  String? _selectedDesignation;

  @override
  void dispose() {
    _nameController.dispose();
    _teacherIdController.dispose();
    _dobController.dispose();
    _designationController.dispose();
    _tagsController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nameFocus.dispose();
    _teacherIdFocus.dispose();
    _designationFocus.dispose();
    _tagsFocus.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              child: Column(
                children: [
                  HeaderWidget(titleLabel: 'Teacher'),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildMainCard(),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppThemeResponsiveness.getMaxWidth(context),
      ),
      child: Card(
        elevation: AppThemeResponsiveness.getCardElevation(context) + 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context) + 4),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: AppThemeResponsiveness.getCardPadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo Section
                  SectionHeader(
                    context: context,
                    title: 'Photo',
                    icon: Icons.camera_alt_rounded,
                    color: Colors.purple,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  PhotoPickerWidget(
                    onImageChanged: (File? file) {
                      setState(() {
                        _selectedImage = file;
                      });
                      if (file != null) {
                        print('Image selected: ${file.path}');
                      } else {
                        print('Image removed');
                      }
                    },
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Personal Information Section
                  SectionHeader(
                    context: context,
                    title: 'Personal Information',
                    icon: Icons.person_rounded,
                    color: Colors.blue,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _nameController,
                    label: 'Full Name *',
                    icon: Icons.person_rounded,
                    validator: (value) => _validateRequired(value, 'Name'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _teacherIdController,
                    label: 'Teacher ID *',
                    icon: Icons.badge_rounded,
                    validator: (value) => _validateRequired(value, 'Teacher ID'),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppDatePicker.dateOfBirth(
                    controller: _dobController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  _buildDesignationDropdown(),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _tagsController,
                    label: 'Tags (Optional)',
                    icon: Icons.local_offer_rounded,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),

                  // Contact Information Section
                  SectionHeader(
                    context: context,
                    title: 'Contact Information',
                    icon: Icons.contact_phone_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _mobileController,
                    label: 'Mobile Number *',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                    validator: _validateMobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                  AppTextFieldBuilder.build(
                    context: context,
                    controller: _emailController,
                    label: 'Email Address *',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDesignation,
      decoration: InputDecoration(
        labelText: 'Designation *',
        labelStyle: AppThemeResponsiveness.getSubHeadingStyle(context),
        prefixIcon: Icon(
          Icons.work_rounded,
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeResponsiveness.getDefaultSpacing(context) * 1.5,
          vertical: AppThemeResponsiveness.getSmallSpacing(context) * 2.5,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _designations.map((String designation) {
        return DropdownMenuItem<String>(
          value: designation,
          child: Text(
            designation,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedDesignation = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a designation';
        }
        return null;
      },
      dropdownColor: Colors.white,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey[600],
        size: AppThemeResponsiveness.getIconSize(context),
      ),
      style: AppThemeResponsiveness.getBodyTextStyle(context),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          title: 'Add Teacher',
          icon: Icon(Icons.save_rounded, color: Colors.white),
          isLoading: _isLoading,
          onPressed: _saveTeacher,
        ),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        SecondaryButton(
          title: 'Cancel',
          icon: Icon(Icons.cancel_rounded, color: AppThemeColor.blue600),
          color: AppThemeColor.blue600,
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      _showErrorDialog('Please select a photo for the teacher');
      return;
    }

    if (_selectedDesignation == null) {
      _showErrorDialog('Please select a designation');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Flexible(
                  child: Text(
                    'Teacher added successfully!',
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 12)),
          ),
          margin: AppThemeResponsiveness.getHorizontalPadding(context),
          elevation: 8,
        ),
      );
      // Navigate back or to next screen
      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Error saving teacher: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getResponsiveRadius(context, 15)),
          ),
          title: Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.red, size: AppThemeResponsiveness.getResponsiveIconSize(context, 30)),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Text(
                'Error',
                style: AppThemeResponsiveness.getTitleTextStyle(context),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}