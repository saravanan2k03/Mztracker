// ignore_for_file: non_constant_identifier_names

import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';

Future send_dep(var dep) async {
  final staff = MockRepository.getStaffByDepartment(dep.toString());
  userList = staff;
}

Future InsertPercntage(var Id) async {
  // mock: no-op
}

Future get_category() async {
  final cats = MockRepository.getCategoryMaps();
  categoryList = cats;
  cat_list = ['- - Choose-Category - -'];
  catid_list = [];
  for (var c in cats) {
    cat_list.add(c['category_text'].toString());
    catid_list.add(c['category_id'] as int);
  }
}

Future<dynamic> send_cat(dynamic text) async {
  final added = MockRepository.addCategory(text.toString().trim());
  if (!added) return 'Already Exist';
  return 'Success';
}

Future send_task(var assignId, taskTitle, assignBy, assignTo, dDate, dTime,
    desc, catId) async {
  final cats = MockRepository.getCategoryMaps();
  final cat = cats.firstWhere(
    (c) => c['category_id'].toString() == catId.toString(),
    orElse: () => {'category_text': 'General'},
  );
  MockRepository.createTask(
    assignId: assignId.toString(),
    taskTitle: taskTitle.toString(),
    assignedBy: assignBy.toString(),
    assignedTo: assignTo.toString(),
    deadlineDate: dDate.toString(),
    deadlineTime: dTime.toString(),
    description: desc.toString(),
    categoryText: cat['category_text'].toString(),
  );
}

Future send_attachment(var assignId, filename, uploadedby) async {
  MockRepository.addAttachment(
      assignId.toString(), filename.toString(), uploadedby.toString());
}
