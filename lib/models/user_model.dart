class UserModel {
  final String employeeId;
  final String employeeName;
  final String profile;
  final String department;
  final String individualStatus;

  UserModel({
    required this.employeeId,
    required this.employeeName,
    required this.profile,
    required this.department,
    this.individualStatus = 'Pending',
  });

  Map<String, dynamic> toMap() => {
        'Employee_id': employeeId,
        'Employee_name': employeeName,
        'profile': profile,
        'department': department,
        'Individual_status': individualStatus,
        'employee_id': employeeId,
        'employee_name': employeeName,
      };
}
