class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role; // 'member' or 'asha_worker'
  final String? aadhaar;
  final String? gender;
  final int? age;
  final String? village;
  final String? bloodGroup;
  final bool? hasChronicDisease;
  final String? chronicDiseaseDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.aadhaar,
    this.gender,
    this.age,
    this.village,
    this.bloodGroup,
    this.hasChronicDisease,
    this.chronicDiseaseDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'aadhaar': aadhaar,
      'gender': gender,
      'age': age,
      'village': village,
      'bloodGroup': bloodGroup,
      'hasChronicDisease': hasChronicDisease,
      'chronicDiseaseDetails': chronicDiseaseDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'member',
      aadhaar: json['aadhaar'],
      gender: json['gender'],
      age: json['age'],
      village: json['village'],
      bloodGroup: json['bloodGroup'],
      hasChronicDisease: json['hasChronicDisease'],
      chronicDiseaseDetails: json['chronicDiseaseDetails'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Create a copy of User with modified fields
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? role,
    String? aadhaar,
    String? gender,
    int? age,
    String? village,
    String? bloodGroup,
    bool? hasChronicDisease,
    String? chronicDiseaseDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      aadhaar: aadhaar ?? this.aadhaar,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      village: village ?? this.village,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      hasChronicDisease: hasChronicDisease ?? this.hasChronicDisease,
      chronicDiseaseDetails: chronicDiseaseDetails ?? this.chronicDiseaseDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
