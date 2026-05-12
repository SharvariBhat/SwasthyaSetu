class DiseaseModel {

  final int diseaseId;

  final String diseaseName;

  final String description;

  final String? status;

  final DateTime? diagnosedDate;

  DiseaseModel({

    required this.diseaseId,

    required this.diseaseName,

    required this.description,

    this.status,

    this.diagnosedDate,
  });

  factory DiseaseModel.fromJson(
      Map<String, dynamic> json) {

    return DiseaseModel(

      diseaseId:
          json['disease_id'] ?? 0,

      diseaseName:
          json['disease_name'] ?? '',

      description:
          json['description'] ?? '',

      status:
          json['status'],

      diagnosedDate:
          json['diagnosed_date'] != null
              ? DateTime.parse(
                  json['diagnosed_date'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'disease_id':
          diseaseId,

      'disease_name':
          diseaseName,

      'description':
          description,

      'status':
          status,

      'diagnosed_date':
          diagnosedDate?.toIso8601String(),
    };
  }
}