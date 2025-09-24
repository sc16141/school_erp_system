// User Role Model
class UserRole1 {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime lastLogin;

  UserRole1({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.lastLogin,
  });
}

// Announcement Model
class Announcement {
  final String id;
  final String title;
  final String content;
  final String priority;
  final DateTime createdDate;
  final String createdBy;
  final bool isActive;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdDate,
    required this.createdBy,
    required this.isActive,
  });
}

// System Setting Model
class SystemSetting {
  final String key;
  final String title;
  final String value;
  final String type; // 'text', 'boolean', 'number'
  final String description;

  SystemSetting({
    required this.key,
    required this.title,
    required this.value,
    required this.type,
    required this.description,
  });
}
