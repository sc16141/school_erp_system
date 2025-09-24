import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionProcessIndicator.dart';
import 'package:school/customWidgets/button.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/snackBar.dart';
import 'package:school/customWidgets/admissionCustomWidgets/admissionCustomInput.dart';

class AdmissionDocumentsScreen extends StatefulWidget {
  @override
  _AdmissionDocumentsScreenState createState() => _AdmissionDocumentsScreenState();
}

class _AdmissionDocumentsScreenState extends State<AdmissionDocumentsScreen> {
  // Document configuration - reduces redundancy
  final List<DocumentConfig> _requiredDocuments = [
    DocumentConfig(
      key: 'passportPhoto',
      title: 'Passport Size Photo',
      subtitle: 'Recent photograph of the student',
      icon: Icons.photo_camera,
      allowedTypes: ['jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'sign',
      title: 'Sign',
      subtitle: 'Present Sign of the student.',
      icon: Icons.pending_actions,
      allowedTypes: ['jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'birthCertificate',
      title: 'Birth Certificate',
      subtitle: 'Official birth certificate',
      icon: Icons.article,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'idProof',
      title: 'ID Proof (Aadhar etc.)',
      subtitle: 'Government issued ID proof',
      icon: Icons.badge,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
  ];

  final List<DocumentConfig> _optionalDocuments = [
    DocumentConfig(
      key: 'transferCertificate',
      title: 'Transfer Certificate',
      subtitle: 'From previous school (if applicable)',
      icon: Icons.school,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'previousReportCard',
      title: 'Previous Report Card',
      subtitle: 'Last academic year report',
      icon: Icons.assessment,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'casteCertificate',
      title: 'Caste Certificate',
      subtitle: 'If applicable for reservations',
      icon: Icons.description,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
    DocumentConfig(
      key: 'medicalCertificate',
      title: 'Medical Certificate',
      subtitle: 'Health certificate from doctor',
      icon: Icons.medical_services,
      allowedTypes: ['pdf', 'jpg', 'jpeg', 'png'],
    ),
  ];

  // Document upload status and file paths
  Map<String, bool> documentStatus = {};
  Map<String, PlatformFile?> selectedFiles = {};
  Map<String, bool> uploadingStatus = {}; // Track individual document upload status

  bool _acceptedTerms = false;
  bool _isGlobalUploading = false; // For submit button loading

  @override
  void initState() {
    super.initState();
    _initializeDocumentMaps();
  }

  void _initializeDocumentMaps() {
    final allDocuments = [..._requiredDocuments, ..._optionalDocuments];
    for (final doc in allDocuments) {
      documentStatus[doc.key] = false;
      selectedFiles[doc.key] = null;
      uploadingStatus[doc.key] = false;
    }
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
                    ProgressIndicatorBar(currentStep: 4, totalSteps: 4),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                    Text(
                      'Document Upload',
                      style: AppThemeResponsiveness.getFontStyle(context),
                    ),
                    SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                    Text(
                      'Please upload all necessary documents for admission',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDocumentSection('Required Documents', _requiredDocuments, true),
                            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                            _buildDocumentSection('Optional Documents', _optionalDocuments, false),
                            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                            _buildInfoContainer(),
                            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                            _buildTermsAndConditionsSection(),
                            SizedBox(height: AppThemeResponsiveness.getExtraLargeSpacing(context)),
                            _buildNavigationButtons(),
                            SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                            _buildSubmitButton(),
                          ],
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

  Widget _buildDocumentSection(String title, List<DocumentConfig> documents, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
        ...documents.map((doc) => DocumentTile(
          config: doc,
          isRequired: isRequired,
          isUploaded: documentStatus[doc.key] ?? false,
          isUploading: uploadingStatus[doc.key] ?? false,
          selectedFile: selectedFiles[doc.key],
          onTap: () => _uploadDocument(doc.key, doc.allowedTypes),
          onRemove: () => _removeDocument(doc.key),
        )).toList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppThemeResponsiveness.getSmallSpacing(context)),
      child: Center(
        child: Text(
          title,
          style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
            color: AppThemeColor.blue600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: Colors.blue[600],
            size: AppThemeResponsiveness.getIconSize(context),
          ),
          SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
          Expanded(
            child: Text(
              'Please ensure all documents are clear and readable. Supported formats: PDF, JPG, PNG (Max 5MB each)',
              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsSection() {
    return Container(
      padding: AppThemeResponsiveness.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: AppThemeColor.blue600,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _acceptedTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
                activeColor: AppThemeColor.blue600,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: AppThemeResponsiveness.getSmallSpacing(context)),
                  child: RichText(
                    text: TextSpan(
                      style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                        color: Colors.grey[700],
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: _showTermsAndConditions,
                            child: Text(
                              'Terms and Conditions',
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                color: AppThemeColor.blue600,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: ' and '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: _showPrivacyPolicy,
                            child: Text(
                              'Privacy Policy',
                              style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                                color: AppThemeColor.blue600,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: ' of the school.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            title: 'Back',
            color: Colors.grey[600]!,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: PrimaryButton(
            title: 'Pay Online',
            onPressed: _acceptedTerms && !_isGlobalUploading ? _payOnline : null,
            icon: Icon(Icons.payment, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryButton(
      title: 'Submit Application',
      onPressed: _acceptedTerms && !_isGlobalUploading ? _submitApplication : null,
      isLoading: _isGlobalUploading,
      icon: Icon(Icons.send, color: Colors.white),
    );
  }

  Future<void> _uploadDocument(String documentKey, List<String> allowedTypes) async {
    try {
      setState(() {
        uploadingStatus[documentKey] = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedTypes,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Check file size (5MB limit)
        if (file.size > 5 * 1024 * 1024) {
          AppSnackBar.show(
            context,
            message: 'File size exceeds 5MB limit. Please choose a smaller file.',
            backgroundColor: Colors.orange,
            icon: Icons.warning,
          );
          return;
        }

        // Store the selected file
        setState(() {
          selectedFiles[documentKey] = file;
          documentStatus[documentKey] = true;
        });

        AppSnackBar.show(
          context,
          message: 'Document selected successfully!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error selecting document: ${e.toString()}',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        uploadingStatus[documentKey] = false;
      });
    }
  }

  void _removeDocument(String documentKey) {
    setState(() {
      selectedFiles[documentKey] = null;
      documentStatus[documentKey] = false;
    });
    AppSnackBar.show(
      context,
      message: 'Document removed successfully!',
      backgroundColor: Colors.orange,
      icon: Icons.info,
    );
  }

  void _submitApplication() {
    // Check if all required documents are uploaded
    bool allRequiredUploaded = _requiredDocuments.every((doc) => documentStatus[doc.key] == true);

    if (!allRequiredUploaded) {
      AppSnackBar.show(
        context,
        message: 'Please upload all required documents!',
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

    if (!_acceptedTerms) {
      AppSnackBar.show(
        context,
        message: 'Please accept Terms & Conditions to proceed!',
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
      return;
    }

    _processApplicationSubmission();
  }

  Future<void> _processApplicationSubmission() async {
    setState(() {
      _isGlobalUploading = true;
    });

    try {
      // Simulate file upload process
      await Future.delayed(Duration(seconds: 2));

      // Generate student ID and show success popup
      String studentId = _generateStudentId();
      _showSuccessPopup(studentId);
    } catch (e) {
      AppSnackBar.show(
        context,
        message: 'Error submitting application: ${e.toString()}',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        _isGlobalUploading = false;
      });
    }
  }

  void _payOnline() {
    if (!_acceptedTerms) {
      AppSnackBar.show(
        context,
        message: 'Please accept Terms & Conditions to proceed!',
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
      return;
    }
    Navigator.pushNamed(context, '/payment-page');
  }

  String _generateStudentId() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2);
    final month = now.month.toString().padLeft(2, '0');
    final random = (1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor();
    return 'STU$year$month$random';
  }

  void _showSuccessPopup(String studentId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: AppThemeResponsiveness.getHeaderIconSize(context),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: Text(
                  'Application Submitted!',
                  style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
                    color: AppThemeColor.blue600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: AppThemeResponsiveness.getDialogWidth(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your admission application has been submitted successfully. You will receive a confirmation email shortly.',
                  style: AppThemeResponsiveness.getBodyTextStyle(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
                Container(
                  padding: AppThemeResponsiveness.getCardPadding(context),
                  decoration: BoxDecoration(
                    color: AppThemeColor.blue600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
                    border: Border.all(
                      color: AppThemeColor.blue600.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Application ID:',
                        style: AppThemeResponsiveness.getCaptionTextStyle(context),
                      ),
                      SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                      Text(
                        studentId,
                        style: AppThemeResponsiveness.getStatValueStyle(context).copyWith(
                          color: AppThemeColor.blue600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                SecondaryButton(
                  title: 'Copy ID',
                  color: AppThemeColor.blue600,
                  onPressed: () => _copyToClipboard(studentId),
                  icon: Icon(
                    Icons.copy,
                    size: AppThemeResponsiveness.getIconSize(context) * 0.7,
                    color: AppThemeColor.blue600,
                  ),
                ),
                SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
                Text(
                  'Please save this ID for future reference and admission status tracking.',
                  style: AppThemeResponsiveness.getCaptionTextStyle(context).copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            PrimaryButton(
              title: 'Continue to Dashboard',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/student-dashboard',
                        (route) => false
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.show(
      context,
      message: 'Application ID copied to clipboard!',
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  void _showTermsAndConditions() {
    TermsAndConditions.show(context);
  }

  void _showPrivacyPolicy() {
    PrivacyPolicy.show(context);
  }
}