import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school/customWidgets/admissionCustomWidgets/feeCommonDataModel.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';



class FacilitiesManagementPage extends StatefulWidget {
  const FacilitiesManagementPage({Key? key}) : super(key: key);

  @override
  State<FacilitiesManagementPage> createState() => _FacilitiesManagementPageState();
}

class _FacilitiesManagementPageState extends State<FacilitiesManagementPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Facility> facilities = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFacilitiesFromCommonModel();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppThemeColor.slideAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  void _loadFacilitiesFromCommonModel() {
    // Load facilities from the common data model
    final commonFacilities = FacilitiesData.getFacilities();

    setState(() {
      facilities = commonFacilities.map((facilityData) {
        // If the common model doesn't have fees, add default fees
        if (facilityData['fees'] == null) {
          facilityData['fees'] = _getDefaultFees(facilityData['name']);
        }
        if (facilityData['isActive'] == null) {
          facilityData['isActive'] = true;
        }
        if (facilityData['createdAt'] == null) {
          facilityData['createdAt'] = DateTime.now().toIso8601String();
        }
        return Facility.fromCommonModel(facilityData);
      }).toList();
    });
  }

  double _getDefaultFees(String facilityName) {
    // Default fees based on facility type
    switch (facilityName.toLowerCase()) {
      case 'library':
        return 500.0;
      case 'sports complex':
        return 1200.0;
      case 'computer lab':
        return 800.0;
      case 'transportation':
        return 2500.0;
      default:
        return 1000.0;
    }
  }

  void _syncWithCommonModel() {
    // Update the common data model with current facilities
    final commonModelData = facilities.map((facility) => facility.toCommonModel()).toList();
    FacilitiesData.updateFacilities(commonModelData);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppThemeColor.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildContentArea(context),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddFacilityButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      child: Text(
        'FACILITIES MANAGEMENT',
        style: AppThemeResponsiveness.getFontStyle(context),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(maxWidth: AppThemeResponsiveness.getMaxWidth(context)),
        margin: EdgeInsets.only(
          top: AppThemeResponsiveness.getSmallSpacing(context),
          left: AppThemeResponsiveness.getMediumSpacing(context),
          right: AppThemeResponsiveness.getMediumSpacing(context),
          bottom: AppThemeResponsiveness.getMediumSpacing(context),
        ),
        decoration: BoxDecoration(
          color: AppThemeColor.white,
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getExtraLargeSpacing(context)),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildFacilitiesList(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFacilitiesList(BuildContext context) {
    if (facilities.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: AppThemeResponsiveness.getScreenPadding(context),
      itemCount: facilities.length,
      itemBuilder: (context, index) => _buildFacilityCard(context, index),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: AppThemeResponsiveness.getIconSize(context) * 3,
            color: Colors.grey[400],
          ),
          SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
          Text(
            'No facilities added yet',
            style: AppThemeResponsiveness.getHeadingStyle(context).copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
          Text(
            'Tap the + button to add your first facility',
            style: AppThemeResponsiveness.getSubHeadingStyle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, int index) {
    final facility = facilities[index];

    return Container(
      margin: AppThemeResponsiveness.getHistoryCardMargin(context),
      decoration: BoxDecoration(
        color: AppThemeColor.white,
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: AppThemeResponsiveness.getCardElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFacilityHeader(context, facility),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildFacilityDescription(context, facility),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildFacilityFees(context, facility),
            SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
            _buildStatusBadge(context, facility),
            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),
            _buildActionButtons(context, index),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityHeader(BuildContext context, Facility facility) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
          decoration: BoxDecoration(
            gradient: AppThemeColor.primaryGradient,
            borderRadius: BorderRadius.circular(AppThemeResponsiveness.getSmallSpacing(context)),
          ),
          child: Icon(
            _getFacilityIcon(facility.name),
            color: AppThemeColor.white,
            size: AppThemeResponsiveness.getIconSize(context),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
        Expanded(
          child: Text(
            facility.name,
            style: AppThemeResponsiveness.getHeadingStyle(context),
          ),
        ),
      ],
    );
  }

  IconData _getFacilityIcon(String facilityName) {
    switch (facilityName.toLowerCase()) {
      case 'library':
        return Icons.library_books;
      case 'sports complex':
        return Icons.sports_tennis;
      case 'computer lab':
        return Icons.computer;
      case 'transportation':
        return Icons.directions_bus;
      default:
        return Icons.business;
    }
  }

  Widget _buildFacilityDescription(BuildContext context, Facility facility) {
    return Text(
      facility.description,
      style: AppThemeResponsiveness.getSubHeadingStyle(context).copyWith(
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildFacilityFees(BuildContext context, Facility facility) {
    return Container(
      padding: AppThemeResponsiveness.getStatusBadgePadding(context),
      decoration: BoxDecoration(
        color: AppThemeColor.blue600.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppThemeColor.blue600,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.currency_rupee,
            size: AppThemeResponsiveness.getStatusBadgeFontSize(context),
            color: AppThemeColor.blue600,
          ),
          Text(
            '${facility.fees.toStringAsFixed(0)} per month',
            style: TextStyle(
              color: AppThemeColor.blue600,
              fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, Facility facility) {
    final statusColor = facility.isActive ? Colors.green : Colors.red;
    final statusText = facility.isActive ? 'Active' : 'Inactive';

    return Container(
      padding: AppThemeResponsiveness.getStatusBadgePadding(context),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor,
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: AppThemeResponsiveness.getStatusBadgeFontSize(context),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int index) {
    if (AppThemeResponsiveness.isMobile(context)) {
      return _buildMobileActionButtons(context, index);
    }
    return _buildDesktopActionButtons(context, index);
  }

  Widget _buildMobileActionButtons(BuildContext context, int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildEditButton(context, index)),
            SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
            Expanded(child: _buildToggleStatusButton(context, index)),
          ],
        ),
        SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context)),
        SizedBox(
          width: double.infinity,
          child: _buildDeleteButton(context, index),
        ),
      ],
    );
  }

  Widget _buildDesktopActionButtons(BuildContext context, int index) {
    return Row(
      children: [
        Expanded(child: _buildEditButton(context, index)),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(child: _buildToggleStatusButton(context, index)),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(child: _buildDeleteButton(context, index)),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, int index) {
    return ElevatedButton.icon(
      onPressed: () => _showEditDialog(index),
      icon: Icon(Icons.edit, size: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
      label: Text(
        'Edit',
        style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
      ),
      style: _getButtonStyle(context, AppThemeColor.blue600),
    );
  }

  Widget _buildToggleStatusButton(BuildContext context, int index) {
    final facility = facilities[index];
    final isActive = facility.isActive;

    return ElevatedButton.icon(
      onPressed: () => _toggleStatus(index),
      icon: Icon(
        isActive ? Icons.toggle_on : Icons.toggle_off,
        size: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
      ),
      label: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
      ),
      style: _getButtonStyle(context, isActive ? Colors.green : Colors.orange),
    );
  }

  Widget _buildDeleteButton(BuildContext context, int index) {
    return ElevatedButton.icon(
      onPressed: () => _showDeleteConfirmation(index),
      icon: Icon(Icons.delete, size: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
      label: Text(
        'Delete',
        style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
      ),
      style: _getButtonStyle(context, Colors.red),
    );
  }

  Widget _buildAddFacilityButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddDialog(),
      backgroundColor: AppThemeColor.blue600,
      child: Icon(
        Icons.add,
        color: AppThemeColor.white,
        size: AppThemeResponsiveness.getIconSize(context),
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: AppThemeColor.white,
      elevation: AppThemeResponsiveness.getButtonElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
      ),
      minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
    );
  }

  void _showAddDialog() {
    _showFacilityDialog(isEditing: false);
  }

  void _showEditDialog(int index) {
    _showFacilityDialog(isEditing: true, facilityIndex: index);
  }

  void _showFacilityDialog({required bool isEditing, int? facilityIndex}) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final feesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (isEditing && facilityIndex != null) {
      final facility = facilities[facilityIndex];
      nameController.text = facility.name;
      descriptionController.text = facility.description;
      feesController.text = facility.fees.toStringAsFixed(0);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        ),
        child: Container(
          width: AppThemeResponsiveness.getDialogWidth(context),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: AppThemeResponsiveness.getScreenPadding(context),
              decoration: BoxDecoration(
                gradient: AppThemeColor.primaryGradient,
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogTitle(context, isEditing),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                    _buildDialogForm(context, nameController, descriptionController, feesController),
                    SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
                    _buildDialogActions(context, isEditing, facilityIndex, formKey, nameController, descriptionController, feesController),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTitle(BuildContext context, bool isEditing) {
    return Text(
      isEditing ? 'Edit Facility' : 'Add New Facility',
      style: AppThemeResponsiveness.getFontStyle(context).copyWith(
        fontSize: AppThemeResponsiveness.getSubHeadingStyle(context).fontSize! * 1.25,
      ),
    );
  }

  Widget _buildDialogForm(BuildContext context, TextEditingController nameController, TextEditingController descriptionController, TextEditingController feesController) {
    return Column(
      children: [
        _buildDialogTextField(
          context: context,
          controller: nameController,
          label: 'Facility Name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter facility name';
            }
            return null;
          },
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildDialogTextField(
          context: context,
          controller: descriptionController,
          label: 'Description',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter facility description';
            }
            return null;
          },
        ),
        SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),
        _buildDialogTextField(
          context: context,
          controller: feesController,
          label: 'Monthly Fees (₹)',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter fees amount';
            }
            final fees = double.tryParse(value);
            if (fees == null || fees < 0) {
              return 'Please enter valid fees amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDialogTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: AppThemeColor.white,
        fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: AppThemeColor.white70,
          fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          borderSide: const BorderSide(color: AppThemeColor.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          borderSide: BorderSide(
            color: AppThemeColor.white,
            width: AppThemeResponsiveness.getFocusedBorderWidth(context),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context, bool isEditing, int? facilityIndex, GlobalKey<FormState> formKey, TextEditingController nameController, TextEditingController descriptionController, TextEditingController feesController) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColor.white.withOpacity(0.2),
              foregroundColor: AppThemeColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
              ),
              side: const BorderSide(color: AppThemeColor.white70),
              minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
            ),
          ),
        ),
        SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleSave(context, isEditing, facilityIndex, formKey, nameController, descriptionController, feesController),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColor.white,
              foregroundColor: AppThemeColor.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppThemeResponsiveness.getButtonBorderRadius(context)),
              ),
              minimumSize: Size(double.infinity, AppThemeResponsiveness.getButtonHeight(context) * 0.8),
            ),
            child: Text(
              isEditing ? 'Update' : 'Add',
              style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSave(BuildContext context, bool isEditing, int? facilityIndex, GlobalKey<FormState> formKey, TextEditingController nameController, TextEditingController descriptionController, TextEditingController feesController) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final fees = double.parse(feesController.text.trim());

    if (isEditing && facilityIndex != null) {
      setState(() {
        facilities[facilityIndex].name = name;
        facilities[facilityIndex].description = description;
        facilities[facilityIndex].fees = fees;
      });
      Navigator.pop(context);
      _showSuccessSnackBar('Facility updated successfully');
    } else {
      final newFacility = Facility(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        fees: fees,
        createdAt: DateTime.now(),
      );
      setState(() {
        facilities.add(newFacility);
      });
      Navigator.pop(context);
      _showSuccessSnackBar('Facility added successfully');
    }

    // Sync with common data model
    _syncWithCommonModel();
  }

  void _toggleStatus(int index) {
    setState(() {
      facilities[index].isActive = !facilities[index].isActive;
    });
    final status = facilities[index].isActive ? 'activated' : 'deactivated';
    _showSuccessSnackBar('Facility $status successfully');

    // Sync with common data model
    _syncWithCommonModel();
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Facility'),
        content: Text('Are you sure you want to delete "${facilities[index].name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFacility(index);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteFacility(int index) {
    final facilityName = facilities[index].name;
    setState(() {
      facilities.removeAt(index);
    });
    _showSuccessSnackBar('$facilityName deleted successfully');

    // Sync with common data model
    _syncWithCommonModel();
  }

  void _showSuccessSnackBar(String message) {
    _showSnackBar(message, Colors.green);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: AppThemeResponsiveness.getBodyTextStyle(context).fontSize),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeResponsiveness.getInputBorderRadius(context)),
        ),
        margin: AppThemeResponsiveness.getScreenPadding(context),
      ),
    );
  }
}