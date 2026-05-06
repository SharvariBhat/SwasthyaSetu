class MedicineModel {

  final int memberMedicineId;
  final int medicineId;

  final String medicineName;

  final String dosage;
  final String timing;
  final String frequency;

  final DateTime? startDate;
  final DateTime? endDate;

  MedicineModel({

    required this.memberMedicineId,
    required this.medicineId,

    required this.medicineName,

    required this.dosage,
    required this.timing,
    required this.frequency,

    this.startDate,
    this.endDate,
  });

  factory MedicineModel.fromJson(
      Map<String, dynamic> json) {

    return MedicineModel(

      memberMedicineId:
          json['member_medicine_id'] ?? 0,

      medicineId:
          json['medicine_id'] ?? 0,

      medicineName:
          json['medicine_name'] ?? '',

      dosage:
          json['dosage'] ?? '',

      timing:
          json['timing'] ?? '',

      frequency:
          json['frequency'] ?? '',

      startDate:
          json['start_date'] != null
              ? DateTime.parse(
                  json['start_date'],
                )
              : null,

      endDate:
          json['end_date'] != null
              ? DateTime.parse(
                  json['end_date'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'member_medicine_id':
          memberMedicineId,

      'medicine_id':
          medicineId,

      'medicine_name':
          medicineName,

      'dosage':
          dosage,

      'timing':
          timing,

      'frequency':
          frequency,

      'start_date':
          startDate?.toIso8601String(),

      'end_date':
          endDate?.toIso8601String(),
    };
  }
}