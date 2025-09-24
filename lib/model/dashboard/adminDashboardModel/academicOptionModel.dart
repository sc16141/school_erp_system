import 'package:flutter/material.dart';

class AcademicOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget Function() route;
  final String stats;

  AcademicOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.route,
    required this.stats,
  });

  Map<String, dynamic> toJson() {
    return {
      'icon': icon.codePoint,
      'title': title,
      'subtitle': subtitle,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'stats': stats,
    };
  }

  // Note: fromJson cannot fully reconstruct route function
  // You'll need to handle route assignment separately
  static AcademicOption fromJson(Map<String, dynamic> json, Widget Function() routeFunction) {
    return AcademicOption(
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      title: json['title'],
      subtitle: json['subtitle'],
      primaryColor: Color(json['primaryColor']),
      secondaryColor: Color(json['secondaryColor']),
      route: routeFunction,
      stats: json['stats'],
    );
  }
}

class AcademicClass {
  final String id;
  final String className;
  final String section;
  final int capacity;
  final String classTeacher;
  final DateTime createdAt;

  AcademicClass({
    required this.id,
    required this.className,
    required this.section,
    required this.capacity,
    required this.classTeacher,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'section': section,
      'capacity': capacity,
      'classTeacher': classTeacher,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AcademicClass.fromJson(Map<String, dynamic> json) {
    return AcademicClass(
      id: json['id'],
      className: json['className'],
      section: json['section'],
      capacity: json['capacity'],
      classTeacher: json['classTeacher'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Subject {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String description;
  final List<String> assignedClasses;
  final DateTime createdAt;

  Subject({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.description,
    required this.assignedClasses,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectName': subjectName,
      'subjectCode': subjectCode,
      'description': description,
      'assignedClasses': assignedClasses,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subjectName'],
      subjectCode: json['subjectCode'],
      description: json['description'],
      assignedClasses: List<String>.from(json['assignedClasses']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class SportGroup {
  final String id;
  final String groupName;
  final String sportType;
  final String coach;
  final int maxMembers;
  final List<String> members;
  final DateTime createdAt;

  SportGroup({
    required this.id,
    required this.groupName,
    required this.sportType,
    required this.coach,
    required this.maxMembers,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupName': groupName,
      'sportType': sportType,
      'coach': coach,
      'maxMembers': maxMembers,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SportGroup.fromJson(Map<String, dynamic> json) {
    return SportGroup(
      id: json['id'],
      groupName: json['groupName'],
      sportType: json['sportType'],
      coach: json['coach'],
      maxMembers: json['maxMembers'],
      members: List<String>.from(json['members']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class HouseGroup {
  final String id;
  final String houseName;
  final String houseColor;
  final String captain;
  final String viceCaptain;
  final int points;
  final List<String> members;
  final DateTime createdAt;

  HouseGroup({
    required this.id,
    required this.houseName,
    required this.houseColor,
    required this.captain,
    required this.viceCaptain,
    required this.points,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseName': houseName,
      'houseColor': houseColor,
      'captain': captain,
      'viceCaptain': viceCaptain,
      'points': points,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HouseGroup.fromJson(Map<String, dynamic> json) {
    return HouseGroup(
      id: json['id'],
      houseName: json['houseName'],
      houseColor: json['houseColor'],
      captain: json['captain'],
      viceCaptain: json['viceCaptain'],
      points: json['points'],
      members: List<String>.from(json['members']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}