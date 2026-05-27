class TaskModel {
  final int id;
  final String title;
  final String? description;
  final String priority;
  final DateTime? dueDate;
  final String status;
  final int userId;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
    required this.status,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      status: json['status'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description ?? '',
      'priority': priority,
      'due_date': dueDate?.toUtc().toIso8601String(),
      'status': status,
    };
  }
}
