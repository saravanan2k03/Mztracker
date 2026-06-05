import '../models/attachment_model.dart';
import '../models/category_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class MockRepository {
  static const _avatar =
      'https://img.freepik.com/premium-psd/3d-illustration-caucasian-man-cartoon-close-up-portrait-standing-man-with-mustache-gray-background-3d-avatar-ui-ux_1020-5090.jpg?w=740';

  // ── Users ──────────────────────────────────────────────────────────────────

  static final Map<String, UserModel> users = {
    'E001': UserModel(employeeId: 'E001', employeeName: 'Saravanan', profile: _avatar, department: 'CSE'),
    'E002': UserModel(employeeId: 'E002', employeeName: 'Kumar',     profile: _avatar, department: 'CSE'),
    'E003': UserModel(employeeId: 'E003', employeeName: 'Priya',     profile: _avatar, department: 'ECE'),
    'E004': UserModel(employeeId: 'E004', employeeName: 'Raj',       profile: _avatar, department: 'EEE'),
    'E005': UserModel(employeeId: 'E005', employeeName: 'Divya',     profile: _avatar, department: 'CSE'),
  };

  // Current logged-in mock user
  static final UserModel currentUser = users['E001']!;

  // ── Categories ─────────────────────────────────────────────────────────────

  static final List<CategoryModel> categories = [
    CategoryModel(categoryId: 1, categoryText: 'Web Development'),
    CategoryModel(categoryId: 2, categoryText: 'Mobile App'),
    CategoryModel(categoryId: 3, categoryText: 'Database'),
    CategoryModel(categoryId: 4, categoryText: 'UI/UX Design'),
    CategoryModel(categoryId: 5, categoryText: 'Testing'),
  ];

  // ── Task definitions ───────────────────────────────────────────────────────

  static final List<TaskModel> _tasks = [
    TaskModel(assignedId: '101', taskTitle: 'Build Dashboard UI',      description: 'Create the main dashboard interface with analytics widgets and charts.', deadlineDate: '30-06-2026', deadlineTime: '5:00 PM', categoryText: 'Web Development', percentage: 0.5,  status: 'Pending',   assignedBy: 'E001', assignedTo: 'E001'),
    TaskModel(assignedId: '102', taskTitle: 'Fix Login Bug',           description: 'Resolve the authentication issue affecting mobile login flow.',          deadlineDate: '20-06-2026', deadlineTime: '3:00 PM', categoryText: 'Mobile App',      percentage: 0.0,  status: 'Pending',   assignedBy: 'E001', assignedTo: 'E001'),
    TaskModel(assignedId: '103', taskTitle: 'Write API Documentation', description: 'Document all REST API endpoints with request/response examples.',        deadlineDate: '15-07-2026', deadlineTime: '6:00 PM', categoryText: 'Database',        percentage: 0.3,  status: 'Pending',   assignedBy: 'E003', assignedTo: 'E001'),
    TaskModel(assignedId: '104', taskTitle: 'Setup Database',          description: 'Configure PostgreSQL for the production environment.',                   deadlineDate: '01-05-2026', deadlineTime: '4:00 PM', categoryText: 'Database',        percentage: 1.0,  status: 'Completed', assignedBy: 'E001', assignedTo: 'E001'),
    TaskModel(assignedId: '105', taskTitle: 'Design Logo',             description: 'Create a new brand logo for the mobile application.',                    deadlineDate: '05-05-2026', deadlineTime: '2:00 PM', categoryText: 'UI/UX Design',    percentage: 1.0,  status: 'Completed', assignedBy: 'E002', assignedTo: 'E001'),
    TaskModel(assignedId: '106', taskTitle: 'Update Server Config',    description: 'Update Nginx configuration for load balancing and SSL termination.',     deadlineDate: '15-04-2026', deadlineTime: '1:00 PM', categoryText: 'Testing',         percentage: 0.0,  status: 'Done late', assignedBy: 'E001', assignedTo: 'E001'),
  ];

  // ── Assignments: taskId → [{empId, individualStatus}] ─────────────────────

  static final Map<String, List<Map<String, String>>> _assignments = {
    '101': [{'empId': 'E001', 'status': 'Pending'},   {'empId': 'E002', 'status': 'Completed'}],
    '102': [{'empId': 'E001', 'status': 'Pending'}],
    '103': [{'empId': 'E001', 'status': 'Pending'},   {'empId': 'E003', 'status': 'Completed'}, {'empId': 'E004', 'status': 'Pending'}],
    '104': [{'empId': 'E001', 'status': 'Completed'}],
    '105': [{'empId': 'E001', 'status': 'Completed'}, {'empId': 'E002', 'status': 'Completed'}],
    '106': [{'empId': 'E001', 'status': 'Completed'}],
  };

  // ── Attachments ────────────────────────────────────────────────────────────

  static final Map<String, List<AttachmentModel>> _attachments = {
    '101': [AttachmentModel(filename: 'requirements.pdf', assignId: '101', uploadedBy: 'E001'), AttachmentModel(filename: 'mockup.png',          assignId: '101', uploadedBy: 'E001')],
    '102': [AttachmentModel(filename: 'bug_report.pdf',  assignId: '102', uploadedBy: 'E001')],
    '103': [],
    '104': [AttachmentModel(filename: 'db_schema.pdf',   assignId: '104', uploadedBy: 'E001')],
    '105': [AttachmentModel(filename: 'logo_v1.png',     assignId: '105', uploadedBy: 'E001'), AttachmentModel(filename: 'logo_v2.png',          assignId: '105', uploadedBy: 'E001')],
    '106': [AttachmentModel(filename: 'server_cfg.txt',  assignId: '106', uploadedBy: 'E001')],
  };

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Returns tasks for a given employee ID and status as raw maps (legacy format).
  static List<Map<String, dynamic>> getTasks(String empId, String status) {
    return _tasks.where((t) {
      final members = _assignments[t.assignedId] ?? [];
      return t.status == status && members.any((m) => m['empId'] == empId);
    }).map((t) => {...t.toMap(), 'Assigned_to': empId}).toList();
  }

  /// Returns [[{row}, {row}]] structure expected by TaskDetailed.getassigndata().
  static List<dynamic> getTaskDetails(String taskId) {
    final task = _tasks.firstWhere((t) => t.assignedId == taskId,
        orElse: () => TaskModel(assignedId: '', taskTitle: '', description: '', deadlineDate: '', deadlineTime: '', categoryText: '', percentage: 0, status: '', assignedBy: '', assignedTo: ''));
    final members = _assignments[taskId] ?? [];
    final rows = members.map((m) => {...task.toMap(), 'Assigned_to': m['empId']!}).toList();
    return [rows];
  }

  /// Returns [[{status_row}]] structure expected by TaskDetailed.getStatus().
  /// Only rows where individual is Completed.
  static List<dynamic> getCompletedStatuses(String taskId) {
    final members = _assignments[taskId] ?? [];
    final completedRows = members
        .where((m) => m['status'] == 'Completed')
        .map((m) => {'Assigned_to': m['empId'], 'Individual_status': 'Completed'})
        .toList();
    return [completedRows];
  }

  /// Returns [[{emp}], [{emp}]] structure expected by TeamMember widget and reassign sheet.
  static List<dynamic> getTeamMemberDetails(String taskId) {
    final members = _assignments[taskId] ?? [];
    return members.map((m) {
      final user = users[m['empId']] ?? currentUser;
      return [{...user.toMap(), 'Individual_status': m['status']}];
    }).toList();
  }

  /// Returns [[{profile}], [{profile}]] indexed by task, for main-page task cards.
  static List<dynamic> getTeamProfiles(List<dynamic> taskIds) {
    return taskIds.map((id) {
      final members = _assignments[id.toString()] ?? [];
      return members.map((m) => {'profile': users[m['empId']]?.profile ?? _avatar}).toList();
    }).toList();
  }

  /// Returns [{Filename}] for attachment widgets.
  static List<Map<String, dynamic>> getAttachments(String taskId) {
    return (_attachments[taskId] ?? []).map((a) => a.toMap()).toList();
  }

  /// Returns category list as raw maps.
  static List<Map<String, dynamic>> getCategoryMaps() {
    return categories.map((c) => c.toMap()).toList();
  }

  /// Returns staff list by department as raw maps.
  static List<Map<String, dynamic>> getStaffByDepartment(String department) {
    return users.values
        .where((u) => u.department == department)
        .map((u) => u.toMap())
        .toList();
  }

  /// Adds a new attachment to a task (mock — keeps in memory).
  static void addAttachment(String taskId, String filename, String uploadedBy) {
    _attachments[taskId] ??= [];
    _attachments[taskId]!.add(AttachmentModel(filename: filename, assignId: taskId, uploadedBy: uploadedBy));
  }

  /// Removes an attachment from a task (mock — in memory only).
  static void deleteAttachment(String taskId, String filename) {
    _attachments[taskId]?.removeWhere((a) => a.filename == filename);
  }

  /// Marks a task as complete (mock — in memory only).
  static void completeTask(String taskId, String status) {
    final idx = _tasks.indexWhere((t) => t.assignedId == taskId);
    if (idx != -1) {
      final t = _tasks[idx];
      _tasks[idx] = TaskModel(
        assignedId: t.assignedId, taskTitle: t.taskTitle, description: t.description,
        deadlineDate: t.deadlineDate, deadlineTime: t.deadlineTime, categoryText: t.categoryText,
        percentage: 1.0, status: status, assignedBy: t.assignedBy, assignedTo: t.assignedTo,
      );
    }
  }

  /// Adds a new category (mock — in memory only).
  static bool addCategory(String text) {
    if (categories.any((c) => c.categoryText.toLowerCase() == text.toLowerCase())) {
      return false;
    }
    categories.add(CategoryModel(categoryId: categories.length + 1, categoryText: text));
    return true;
  }

  /// Creates a new task (mock — in memory only).
  static void createTask({
    required String assignId,
    required String taskTitle,
    required String assignedBy,
    required String assignedTo,
    required String deadlineDate,
    required String deadlineTime,
    required String description,
    required String categoryText,
  }) {
    _tasks.add(TaskModel(
      assignedId: assignId, taskTitle: taskTitle, description: description,
      deadlineDate: deadlineDate, deadlineTime: deadlineTime, categoryText: categoryText,
      percentage: 0.0, status: 'Pending', assignedBy: assignedBy, assignedTo: assignedTo,
    ));
    _assignments[assignId] = [{'empId': assignedTo, 'status': 'Pending'}];
  }
}
