class ModelFingerContactsMain {
  int userId;
  ModelFingerContactsOld modelFingerContactsOld;
  ModelFingerContactsMain({
    required this.userId,
    required this.modelFingerContactsOld,
  });

  factory ModelFingerContactsMain.fromMap(Map<String, dynamic> map) {
    return ModelFingerContactsMain(
      userId: map['user_id'],
      modelFingerContactsOld: ModelFingerContactsOld.fromMap(map['data']),
    );
  }
}

class ModelFingerContactsOld {
  ModelFingerContactsList modelFingerContactsList;
  ModelFingerContactsPostsList modelFingerContactsPostsList;
  ModelFingerContactsOld({
    required this.modelFingerContactsList,
    required this.modelFingerContactsPostsList,
  });

  factory ModelFingerContactsOld.fromMap(Map<String, dynamic> map) {
    return ModelFingerContactsOld(
      modelFingerContactsList:
          ModelFingerContactsList.fromMap(map['contacts20']),
      modelFingerContactsPostsList:
          ModelFingerContactsPostsList.fromMap(map['posts']),
    );
  }
}

class ModelFingerContactsPostsList {
  List<ModelFingerContactsPosts> list;
  ModelFingerContactsPostsList({
    required this.list,
  });

  factory ModelFingerContactsPostsList.fromMap(List<dynamic> map) {
    return ModelFingerContactsPostsList(
        list: map.map((e) => ModelFingerContactsPosts.fromMap(e)).toList());
  }
}

class ModelFingerContactsPosts {
  int postId;
  String? proPic;
  String text;
  ModelFingerContactsUser modelFingerContactsUser;
  List<String> listFour = [];
  String comments;
  bool? postLiked;
  ModelFingerContactsPosts(
      {required this.postId,
      required this.proPic,
      required this.text,
      required this.modelFingerContactsUser,
      required this.listFour,
      required this.comments,
      required this.postLiked});

  factory ModelFingerContactsPosts.fromMap(Map<String, dynamic> map) {
    return ModelFingerContactsPosts(
        postId: map['post_id'],
        proPic: map['pro_pic'],
        text: map['text'],
        modelFingerContactsUser: ModelFingerContactsUser.fromMap(map['user']),
        listFour: map['last_four_post_pic'],
        comments: map['comments'],
        postLiked: map['post_liked']);
  }
}

class ModelFingerContactsUser {
  String username;
  String? proPic;
  String? bio;
  ModelFingerContactsUser(
      {required this.username, required this.proPic, required this.bio});

  factory ModelFingerContactsUser.fromMap(Map<String, dynamic> map) {
    return ModelFingerContactsUser(
      username: map['username'],
      proPic: map['pro_pic'],
      bio: map['bio'],
    );
  }
}

class ModelFingerContactsList {
  List<ModelFingerContacts> list;
  ModelFingerContactsList({
    required this.list,
  });

  factory ModelFingerContactsList.fromMap(List<dynamic> map) {
    return ModelFingerContactsList(
        list: map.map((e) => ModelFingerContacts.fromMap(e)).toList());
  }
}

class ModelFingerContacts {
  int id;
  String? proPic;
  String username;
  ModelFingerContacts({
    required this.id,
    required this.proPic,
    required this.username,
  });

  factory ModelFingerContacts.fromMap(Map<String, dynamic> map) {
    return ModelFingerContacts(
      id: map['id'],
      proPic: map['pro_pic'],
      username: map['username'],
    );
  }
}
