import 'package:flutter/material.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionProcessIndicator.dart';
import 'package:school/customWidgets/admissionCustomWidgets/backAndNextButton.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/dropDownCommon.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/datePicker.dart';

class AdmissionBasicInfoScreen extends StatefulWidget {
  @override
  _AdmissionBasicInfoScreenState createState() => _AdmissionBasicInfoScreenState();
}

class _AdmissionBasicInfoScreenState extends State<AdmissionBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _aadharController = TextEditingController();
  final _previousSchoolController = TextEditingController();

  // Date picker controllers
  final _dateOfBirthController = TextEditingController();
  final _admissionDateController = TextEditingController();

  bool _showOtpButton = false;
  bool _showOtpField = false;
  bool _otpSent = false;
  final TextEditingController _otpController = TextEditingController();

  String _selectedClass = 'Nursery';
  String _selectedAcademicYear = '2025-2026';
  String _selectedStudentType = 'New';
  String? _selectedGender;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneNumberChanged);

    // Set default dates using the controllers
    _dateOfBirthController.text = _formatDate(DateTime.now().subtract(Duration(days: 365 * 5)));
    _admissionDateController.text = _formatDate(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _aadharController.dispose();
    _previousSchoolController.dispose();
    _dateOfBirthController.dispose();
    _admissionDateController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _onPhoneNumberChanged() {
    setState(() {
      _showOtpButton = _phoneController.text.length >= 10;
      if (_otpSent) {
        _showOtpField = false;
        _otpSent = false;
        _otpController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppThemeResponsiveness.getMaxWidth(context),
              ),
              child: SingleChildScrollView(
                padding: AppThemeResponsiveness.getScreenPadding(context),
                child: Column(
                  children: [
                    ProgressIndicatorBar(currentStep: 1, totalSteps: 4),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                    Text(
                      'Student Information',
                      style: AppThemeResponsiveness.getFontStyle(context),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      'Please fill in all the required information',
                      style: AppThemeResponsiveness.getSplashSubtitleStyle(context),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                    Card(
                      elevation: AppThemeResponsiveness.getCardElevation(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      ),
                      child: Padding(
                        padding: AppThemeResponsiveness.getCardPadding(context),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _nameController,
                                label: 'Full Name *',
                                icon: Icons.person,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter student name' : null,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable date picker for Date of Birth
                              AppDatePicker.dateOfBirth(
                                controller: _dateOfBirthController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select date of birth';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable dropdown for Gender
                              AppDropdown.gender(
                                value: _selectedGender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _nationalityController,
                                label: 'Nationality *',
                                icon: Icons.flag,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter nationality' : null,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _aadharController,
                                label: 'Aadhaar Number / National ID *',
                                icon: Icons.credit_card,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Please enter Aadhar/National ID';
                                  if (value.length < 10) return 'Please enter valid ID number';
                                  return null;
                                },
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable dropdown for Category
                              AppDropdown.category(
                                value: _selectedCategory,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable dropdown for Academic Year
                              AppDropdown.academicYear(
                                value: _selectedAcademicYear,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAcademicYear = newValue!;
                                  });
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable dropdown for Class
                              AppDropdown.classGrade(
                                value: _selectedClass,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedClass = newValue!;
                                  });
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable date picker for Admission Date
                              AppDatePicker.admissionDate(
                                controller: _admissionDateController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select admission date';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

                              // Using reusable dropdown for Student Type
                              AppDropdown.studentType(
                                value: _selectedStudentType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedStudentType = newValue!;
                                  });
                                },
                              ),

                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              // Show Previous School field only when Transfer is selected
                              if (_selectedStudentType == 'Transfer') ...[
                                AppTextFieldBuilder.build(
                                  context: context,
                                  controller: _previousSchoolController,
                                  label: 'Previous School *',
                                  icon: Icons.school,
                                  validator: (value) =>
                                  value!.isEmpty ? 'Please enter previous school name' : null,
                                ),
                                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              ],
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _emailController,
                                label: 'Email *',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Please enter email';
                                  if (!value.contains('@')) return 'Please enter valid email';
                                  return null;
                                },
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              _buildPhoneFieldWithOTP(),
                              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                              FormNavigationButtons(
                                onNext: _nextPage,
                                onBack: () => Navigator.pop(context),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneFieldWithOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Phone number field with onChanged callback
        AppTextFieldBuilder.build(
          context: context,
          controller: _phoneController,
          label: 'Phone Number *',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              _showOtpButton = value.length >= 10;
              if (_otpSent) {
                _showOtpField = false;
                _otpSent = false;
                _otpController.clear();
              }
            });
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter phone number';
            if (value.length < 10) return 'Please enter valid phone number';
            return null;
          },
        ),

        // Show OTP button when phone number is valid
        if (_showOtpButton && !_otpSent) ...[
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          PrimaryButton(
            title: 'Send OTP',
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: _sendOtp,
          ),
        ],

        // Show OTP input field after OTP is sent
        if (_showOtpField) ...[
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          AppTextFieldBuilder.build(
            context: context,
            controller: _otpController,
            label: 'Enter Verification Code',
            icon: Icons.security,
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter verification code';
              }
              if (value.length != 6) {
                return 'Verification code must be 6 digits';
              }
              return null;
            },
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          PrimaryButton(
            title: 'Verify OTP',
            icon: Icon(Icons.verified, color: Colors.white),
            onPressed: _verifyOtp,
          ),
        ],
      ],
    );
  }

  void _sendOtp() {
    setState(() {
      _showOtpField = true;
      _otpSent = true;
      _showOtpButton = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP sent successfully!',
          style: AppThemeResponsiveness.getBodyTextStyle(context),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _verifyOtp() {
    if (_otpController.text.length == 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Phone number verified successfully!',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid 6-digit OTP',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      // Check if phone number is verified (OTP validation)
      if (_phoneController.text.isNotEmpty && !_otpSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please verify your phone number first',
              style: AppThemeResponsiveness.getBodyTextStyle(context),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_otpSent && _otpController.text.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter and verify the 6-digit OTP',
              style: AppThemeResponsiveness.getBodyTextStyle(context),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // All validations passed, proceed to next screen
      // You can pass the form data to the next screen here
      Map<String, dynamic> formData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'nationality': _nationalityController.text,
        'aadhar': _aadharController.text,
        'previousSchool': _previousSchoolController.text,
        'selectedClass': _selectedClass,
        'selectedAcademicYear': _selectedAcademicYear,
        'selectedStudentType': _selectedStudentType,
        'selectedGender': _selectedGender,
        'selectedCategory': _selectedCategory,
        'dateOfBirth': _dateOfBirthController.text,
        'admissionDate': _admissionDateController.text,
      };

      // Navigate to next screen (replace with your actual next screen)
      Navigator.pushNamed(
        context,
        '/admission-parent-info', // Replace with your route name
        arguments: formData,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: AppThemeResponsiveness.getBodyTextStyle(context),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}