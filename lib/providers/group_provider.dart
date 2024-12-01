import 'package:flutter/foundation.dart';
import 'package:delivery_app_emilio_puigcerver/models/group.dart';

class GroupProvider with ChangeNotifier {
  final List<Group> _groups = [];

  List<Group> get groups => _groups;

  void addGroup(Group group) {
    _groups.add(group);
    notifyListeners();
  }

  void updateGroup(Group group) {
    int index = _groups.indexWhere((g) => g.id == group.id);
    if (index != -1) {
      _groups[index] = group;
      notifyListeners();
    }
  }

  void removeGroup(String groupId) {
    _groups.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }
}
