class MedicalRecordModel {

  final int recordId;

  final String recordType;

  final String fileUrl;

  final String diagnosis;

  final String doctorName;

  final DateTime? recordDate;

  MedicalRecordModel({

    required this.recordId,

    required this.recordType,

    required this.fileUrl,

    required this.diagnosis,

    required this.doctorName,

    this.recordDate,
  });

  factory MedicalRecordModel.fromJson(
      Map<String, dynamic> json) {

    return MedicalRecordModel(

      recordId:
          json['record_id'] ?? 0,

      recordType:
          json['record_type'] ?? '',

      fileUrl:
          json['file_url'] ?? '',

      diagnosis:
          json['diagnosis'] ?? '',

      doctorName:
          json['doctor_name'] ?? '',

      recordDate:
          json['record_date'] != null
              ? DateTime.parse(
                  json['record_date'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'record_id':
          recordId,

      'record_type':
          recordType,

      'file_url':
          fileUrl,

      'diagnosis':
          diagnosis,

      'doctor_name':
          doctorName,

      'record_date':
          recordDate?.toIso8601String(),
    };
  }
}