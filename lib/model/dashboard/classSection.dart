class ClassSection {
  final String id;
  final String className;
  final String sectionName;
  final String? classTeacherId;
  final List<String> subjectTeacherIds;
  final int maxStudents;
  final int currentStudents;
  final String room;
  final DateTime createdAt;
  final bool isActive;

  ClassSection({
    required this.id,
    required this.className,
    required this.sectionName,
    this.classTeacherId,
    required this.subjectTeacherIds,
    required this.maxStudents,
    this.currentStudents = 0,
    required this.room,
    required this.createdAt,
    this.isActive = true,
  });

  ClassSection copyWith({
    String? id,
    String? className,
    String? sectionName,
    String? classTeacherId,
    List<String>? subjectTeacherIds,
    int? maxStudents,
    int? currentStudents,
    String? room,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return ClassSection(
      id: id ?? this.id,
      className: className ?? this.className,
      sectionName: sectionName ?? this.sectionName,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      subjectTeacherIds: subjectTeacherIds ?? this.subjectTeacherIds,
      maxStudents: maxStudents ?? this.maxStudents,
      currentStudents: currentStudents ?? this.currentStudents,
      room: room ?? this.room,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  String get fullName => '$className-$sectionName';
}
