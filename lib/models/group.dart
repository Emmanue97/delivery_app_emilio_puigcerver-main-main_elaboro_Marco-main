class Group {
  String id;
  String name;
  List<Member> members;

  Group({required this.id, required this.name, required this.members});
}

class Member {
  String id;
  String name;
  double salary;

  Member({required this.id, required this.name, required this.salary});
}
