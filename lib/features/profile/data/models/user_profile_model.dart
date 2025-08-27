import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.uid,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.age,
    required super.weight,
    required super.height,
    required super.gender,
    required super.birthDate,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserProfileModel.fromUserModel(dynamic userModel) {
    return UserProfileModel(
      uid: userModel.uid,
      email: userModel.email,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      phone: userModel.phone,
      age: userModel.age,
      weight: userModel.weight,
      height: userModel.height,
      gender: userModel.gender,
      birthDate: userModel.birthDate,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
