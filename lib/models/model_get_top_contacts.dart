class ModelGetTopContactsList {
  List<ModelGetTopContacts> list;
  ModelGetTopContactsList({
    required this.list,
  });

  factory ModelGetTopContactsList.fromMap(List<dynamic> map) {
    return ModelGetTopContactsList(
        list: map.map((e) => ModelGetTopContacts.fromMap(e)).toList());
  }
}

class ModelGetTopContacts {
  String contactNumber;
  String firtsName;
  String lastName;
  String picture;
  String bio;
  ModelGetTopContacts({
    required this.contactNumber,
    required this.firtsName,
    required this.lastName,
    required this.picture,
    required this.bio,
  });

  factory ModelGetTopContacts.fromMap(Map<String, dynamic> map) {
    return ModelGetTopContacts(
      contactNumber: map['contact_number'],
      firtsName: map['first_name'],
      lastName: map['last_name'],
      picture: map['picture'] ?? "",
      bio: map['bio'],
    );
  }
}
