class ReminderModel {

  final int reminderId;

  final String type;

  final String? title;

  final String reminderTime;

  final String status;

  ReminderModel({

    required this.reminderId,

    required this.type,

    this.title,

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

      title:
          json['title'],

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

      'title':
          title,

      'reminder_time':
          reminderTime,

      'status':
          status,
    };
  }
}