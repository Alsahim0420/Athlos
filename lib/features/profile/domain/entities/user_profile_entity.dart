abstract class UserProfileEntity {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final int age;
  final double weight;
  final double height;
  final String gender;
  final DateTime birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
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

  String get fullName => '$firstName $lastName';
  
  double get bmi => weight / ((height / 100) * (height / 100));
  
  String get bmiCategory {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileEntity && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'UserProfileEntity(uid: $uid, fullName: $fullName, email: $email)';
  }
}
