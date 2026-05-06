class SymptomModel {

  final int logId;

  final String symptom;

  final String severity;

  final DateTime? logDate;

  SymptomModel({

    required this.logId,

    required this.symptom,

    required this.severity,

    this.logDate,
  });

  factory SymptomModel.fromJson(
      Map<String, dynamic> json) {

    return SymptomModel(

      logId:
          json['log_id'] ?? 0,

      symptom:
          json['symptom'] ?? '',

      severity:
          json['severity'] ?? '',

      logDate:
          json['log_date'] != null
              ? DateTime.parse(
                  json['log_date'],
                )
              : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'log_id':
          logId,

      'symptom':
          symptom,

      'severity':
          severity,

      'log_date':
          logDate?.toIso8601String(),
    };
  }
}