class TaskModel {
  final String assignedId;
  final String taskTitle;
  final String description;
  final String deadlineDate;
  final String deadlineTime;
  final String categoryText;
  final double percentage;
  final String status;
  final String assignedBy;
  final String assignedTo;

  TaskModel({
    required this.assignedId,
    required this.taskTitle,
    required this.description,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.categoryText,
    required this.percentage,
    required this.status,
    required this.assignedBy,
    required this.assignedTo,
  });

  Map<String, dynamic> toMap() => {
        'Assigned_Id': assignedId,
        'Task_Tittle': taskTitle,
        'description': description,
        'Deadline_date': deadlineDate,
        'Deadline_time': deadlineTime,
        'Category_text': categoryText,
        'percentage': percentage.toString(),
        'status': status,
        'Assigned_by': assignedBy,
        'Assigned_to': assignedTo,
      };
}
