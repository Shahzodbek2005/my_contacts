import 'dart:convert';

class ListModelSaveContact {
  List<ModelSaveContact> list;
  ListModelSaveContact({
    required this.list,
  });

  factory ListModelSaveContact.fromMap(List<dynamic> map) {
    return ListModelSaveContact(
        list: map.map((e) => ModelSaveContact.fromMap(e)).toList());
  }
}

class ModelSaveContact {
  String name;
  String phone;
  ModelSaveContact({
    required this.name,
    required this.phone,
  });

  factory ModelSaveContact.fromMap(Map<String, dynamic> map) {
    return ModelSaveContact(
      name: map['name'],
      phone: map['number'],
    );
  }
}
