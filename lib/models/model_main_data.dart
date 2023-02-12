import 'dart:convert';

class ContactsCircleList {
  List<ContactsCircle> list;
  ContactsCircleList({
    required this.list,
  });

  factory ContactsCircleList.fromMap(List<dynamic> map) {
    return ContactsCircleList(
      list: map.map((e) => ContactsCircle.fromMap(e)).toList(),
    );
  }
}

class PostsUser {
  String username;
  String proPic;
  String bio;
  PostsUser({
    required this.username,
    required this.proPic,
    required this.bio,
  });

  factory PostsUser.fromMap(Map<String, dynamic> map) {
    return PostsUser(
      username: map['username'],
      proPic: map['pro_pic'],
      bio: map['bio'],
    );
  }
}

class ModelMainDataMain {
  int userId;
  Data data;
  ModelMainDataMain({
    required this.userId,
    required this.data,
  });

  factory ModelMainDataMain.fromMap(Map<String, dynamic> map) {
    return ModelMainDataMain(
      userId: map['user_id'],
      data: Data.fromMap(map['data']),
    );
  }
}

class Posts {
  int postId;
  String picture;
  String text;
  PostsUser postsUser;
  List<String> list;
  String comments;
  bool postLiked;
  Posts({
    required this.postId,
    required this.picture,
    required this.text,
    required this.postsUser,
    required this.list,
    required this.comments,
    required this.postLiked,
  });

  factory Posts.fromMap(Map<String, dynamic> map) {
    return Posts(
      postId: map['post_id'],
      picture: map['picture'],
      text: map['text'],
      postsUser: PostsUser.fromMap(map["user"]),
      list: List<String>.from(map['last_four_post_pic']),
      comments: map['comments'],
      postLiked: map['post_liked'],
    );
  }
}

class PostsList {
  List<Posts> list;
  PostsList({
    required this.list,
  });

  factory PostsList.fromMap(List<dynamic> map) {
    return PostsList(
      list: map.map((e) => Posts.fromMap(e)).toList(),
    );
  }
}

class Data {
  PostsList postsList;
  ContactsCircleList circleList;
  Data({
    required this.postsList,
    required this.circleList,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      postsList: PostsList.fromMap(map['posts']),
      circleList: ContactsCircleList.fromMap(map['contacts20']),
    );
  }
}

class ContactsCircle {
  int id;
  String? proPic;
  String username;
  ContactsCircle({
    required this.id,
    required this.proPic,
    required this.username,
  });

  factory ContactsCircle.fromMap(Map<String, dynamic> map) {
    return ContactsCircle(
      id: map['id'],
      proPic: map['pro_pic'],
      username: map['username'],
    );
  }
}
