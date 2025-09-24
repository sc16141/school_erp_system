import 'package:flutter/material.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionProcessIndicator.dart';
import 'package:school/customWidgets/admissionCustomWidgets/backAndNextButton.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/inputField.dart';
import 'package:school/customWidgets/sectionTitle.dart';

class AdmissionParentInfoScreen extends StatefulWidget {
  @override
  _AdmissionParentInfoScreenState createState() => _AdmissionParentInfoScreenState();
}

class _AdmissionParentInfoScreenState extends State<AdmissionParentInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fatherNameController = TextEditingController();
  final _fatherOccupationController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherOccupationController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianRelationshipController = TextEditingController();
  final _guardianContactController = TextEditingController();

  @override
  void dispose() {
    _fatherNameController.dispose();
    _fatherOccupationController.dispose();
    _motherNameController.dispose();
    _motherOccupationController.dispose();
    _guardianNameController.dispose();
    _guardianRelationshipController.dispose();
    _guardianContactController.dispose();
    super.dispose();
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
                    ProgressIndicatorBar(currentStep: 2, totalSteps: 4),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                    Text(
                      'Parent/Guardian Information',
                      style: AppThemeResponsiveness.getFontStyle(context),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      'Please provide details about parent/guardian',
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
                              SectionTitleBlueAdmission(title: 'Father\'s Information'),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _fatherNameController,
                                label: 'Father\'s Name *',
                                icon: Icons.person,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter father\'s name' : null,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller:_fatherOccupationController,
                                label: 'Father\'s Occupation',
                                icon: Icons.work,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                              SectionTitleBlueAdmission(title: 'Mother\'s Information'),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _motherNameController,
                                label: 'Mother\'s Name *',
                                icon: Icons.person,
                                validator: (value) =>
                                value!.isEmpty ? 'Please enter mother\'s name' : null,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _motherOccupationController,
                                label: 'Mother\'s Occupation',
                                icon: Icons.work,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                              SectionTitleBlueAdmission(title: 'Guardian Information (if different)'),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _guardianNameController,
                                label: 'Guardian Name',
                                icon: Icons.person_outline,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _guardianRelationshipController,
                                label: 'Relationship with Student',
                                icon: Icons.family_restroom,
                              ),
                              SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                              AppTextFieldBuilder.build(
                                context: context,
                                controller: _guardianContactController,
                                label: 'Guardian Contact Number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty && value.length < 10) {
                                    return 'Please enter valid phone number';
                                  }
                                  return null;
                                },
                              ),
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

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      // Save data and navigate to next page
      Navigator.pushNamed(context, '/admission-contact');
    }
  }
}