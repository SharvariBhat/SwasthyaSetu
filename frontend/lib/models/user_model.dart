import 'dart:convert';

class User {

  final String id;
  final String name;
  final String phone;
  final String role;

  final String? aadhaar;
  final String? gender;
  final int? age;
  final String? village;
  final String? bloodGroup;

  final String? allergies;
  final String? chronicConditions;
  final bool? takingMedicineNow;

  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,

    this.aadhaar,
    this.gender,
    this.age,
    this.village,
    this.bloodGroup,

    this.allergies,
    this.chronicConditions,
    this.takingMedicineNow,

    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    return User(

      id: json['user_id']?.toString() ?? '',

      name: json['name'] ?? '',

      phone: json['phone'] ?? '',

      role: json['role'] ?? '',

      aadhaar: json['aadhaar_num'],

      gender: json['gender'],

      age: json['age'],

      village: json['village'],

      bloodGroup: json['blood_group'],

      allergies: json['allergies'],

      chronicConditions: json['chronic_conditions'],

      takingMedicineNow:
          json['taking_medicine_now'] == 'YES',

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'user_id': id,

      'name': name,

      'phone': phone,

      'role': role,

      'aadhaar_num': aadhaar,

      'gender': gender,

      'age': age,

      'village': village,

      'blood_group': bloodGroup,

      'allergies': allergies,

      'chronic_conditions': chronicConditions,

      'taking_medicine_now':
          takingMedicineNow == true
              ? 'YES'
              : 'NO',

      'created_at':
          createdAt?.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());

  static User decode(String source) =>
      User.fromJson(jsonDecode(source));
}