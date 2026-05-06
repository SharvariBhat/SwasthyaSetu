class ReminderModel {

  final int reminderId;

  final String type;

  final String reminderTime;

  final String status;

  ReminderModel({

    required this.reminderId,

    required this.type,

    required this.reminderTime,

    required this.status,
  });

  factory ReminderModel.fromJson(
      Map<String, dynamic> json) {

    return ReminderModel(

      reminderId:
          json['reminder_id'] ?? 0,

      type:
          json['type'] ?? '',

      reminderTime:
          json['reminder_time'] ?? '',

      status:
          json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {

      'reminder_id':
          reminderId,

      'type':
          type,

      'reminder_time':
          reminderTime,

      'status':
          status,
    };
  }
}