import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final int age;
  final double weight; // in kilograms
  final double height; // in centimeters
  final String gender;
  final DateTime birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'birthDate': Timestamp.fromDate(birthDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
      weight: (data['weight'] ?? 0).toDouble(),
      height: (data['height'] ?? 0).toDouble(),
      gender: data['gender'] ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Map (for form data)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'] ?? DateTime.now(),
      createdAt: map['createdAt'] ?? DateTime.now(),
      updatedAt: map['updatedAt'] ?? DateTime.now(),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    int? age,
    double? weight,
    double? height,
    String? gender,
    DateTime? birthDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Get full name
  String get fullName => '$firstName $lastName';

  // Get BMI
  double get bmi {
    if (height > 0) {
      double heightInMeters = height / 100;
      return weight / (heightInMeters * heightInMeters);
    }
    return 0;
  }

  // Get BMI category
  String get bmiCategory {
    if (bmi == 0) return 'N/A';
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }
}
