import 'dart:math';

class UserModel {
  final String userId;
  final String name;
  final String userIcon;
  final String userIconBg;
  final String usernor;
  final String introduction;
  final String signa;
  final List<PostModel> post;
  final int followerCount;
  final int followingCount;
  final int likeCount;

  // 聊天页面需要的字段
  String get usericon => userIcon; // 兼容性别名
  String get chatBg => userIconBg; // 使用用户背景图作为聊天背景

  UserModel({
    required this.userId,
    required this.name,
    required this.userIcon,
    required this.userIconBg,
    required this.usernor,
    required this.introduction,
    required this.signa,
    required this.post,
    int? followerCount,
    int? followingCount,
    int? likeCount,
  }) : followerCount = followerCount ?? _generateRandomCount(),
       followingCount = followingCount ?? _generateRandomCount(),
       likeCount = likeCount ?? _generateRandomCount();

  static int _generateRandomCount() {
    final Random random = Random();
    return 100 + random.nextInt(901); // 100-1000
  }

  String get followerCountFormatted {
    if (followerCount >= 1000) {
      return '${(followerCount / 1000).toStringAsFixed(0)}k';
    }
    return followerCount.toString();
  }

  String get followingCountFormatted {
    if (followingCount >= 1000) {
      return '${(followingCount / 1000).toStringAsFixed(0)}k';
    }
    return followingCount.toString();
  }

  String get likeCountFormatted {
    return likeCount.toString();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      userIcon: json['userIcon'] ?? '',
      userIconBg: json['userIconBg'] ?? '',
      usernor: json['usernor'] ?? '',
      introduction: json['Introduction'] ?? '',
      signa: json['signa'] ?? '',
      post: (json['post'] as List<dynamic>?)
          ?.map((postJson) => PostModel.fromJson(postJson))
          .toList() ?? [],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      likeCount: json['likeCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'userIcon': userIcon,
      'userIconBg': userIconBg,
      'usernor': usernor,
      'Introduction': introduction,
      'signa': signa,
      'post': post.map((p) => p.toJson()).toList(),
      'followerCount': followerCount,
      'followingCount': followingCount,
      'likeCount': likeCount,
    };
  }
}

class PostModel {
  final String postId;
  final String postmsg;
  final String isVideo;
  final String? playVideo;
  final String? postPic1;
  final String? postPic2;
  final String? postPic3;

  PostModel({
    required this.postId,
    required this.postmsg,
    required this.isVideo,
    this.playVideo,
    this.postPic1,
    this.postPic2,
    this.postPic3,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      postmsg: json['postmsg'] ?? '',
      isVideo: json['isVideo'] ?? '0',
      playVideo: json['playVideo'],
      postPic1: json['post_pic_1'],
      postPic2: json['post_pic_2'],
      postPic3: json['post_pic_3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'postmsg': postmsg,
      'isVideo': isVideo,
      'playVideo': playVideo,
      'post_pic_1': postPic1,
      'post_pic_2': postPic2,
      'post_pic_3': postPic3,
    };
  }
}

class UserDataModel {
  final List<UserModel> allData;

  UserDataModel({required this.allData});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      allData: (json['allData'] as List<dynamic>?)
          ?.map((userJson) => UserModel.fromJson(userJson))
          .toList() ?? [],
    );
  }
} 