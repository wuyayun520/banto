import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  static const String _userProfileKey = 'user_profile';
  
  // 默认用户资料
  static const String _defaultName = 'Darlene Beats';
  static const String _defaultSignature = 'An ordinary perfume collector';
  static const String _defaultAvatar = 'assets/images/banto_s/1/pic/pic_1.jpg';
  
  // 预设头像列表
  static const List<String> _presetAvatars = [
    'assets/images/banto_s/1/pic/pic_1.jpg',
    'assets/images/banto_s/1/pic/pic_2.jpg',
    'assets/images/banto_s/1/pic/pic_3.jpg',
    'assets/images/banto_s/2/pic/pic_1.jpg',
    'assets/images/banto_s/2/pic/pic_2.jpg',
    'assets/images/banto_s/2/pic/pic_3.jpg',
    'assets/images/banto_s/3/pic/pic_1.jpg',
    'assets/images/banto_s/3/pic/pic_2.jpg',
    'assets/images/banto_s/3/pic/pic_3.jpg',
    'assets/images/banto_s/4/pic/pic_1.jpg',
    'assets/images/banto_s/4/pic/pic_2.jpg',
    'assets/images/banto_s/4/pic/pic_3.jpg',
    'assets/images/banto_s/5/pic/pic_1.jpg',
    'assets/images/banto_s/5/pic/pic_2.jpg',
    'assets/images/banto_s/5/pic/pic_3.jpg',
    'assets/images/banto_s/6/pic/pic_1.jpg',
    'assets/images/banto_s/6/pic/pic_2.jpg',
    'assets/images/banto_s/6/pic/pic_3.jpg',
    'assets/images/banto_s/7/pic/pic_1.jpg',
    'assets/images/banto_s/7/pic/pic_2.jpg',
    'assets/images/banto_s/7/pic/pic_3.jpg',
    'assets/images/banto_s/8/pic/pic_1.jpg',
    'assets/images/banto_s/8/pic/pic_2.jpg',
    'assets/images/banto_s/8/pic/pic_3.jpg',
    'assets/images/banto_s/9/pic/pic_1.jpg',
    'assets/images/banto_s/9/pic/pic_2.jpg',
    'assets/images/banto_s/9/pic/pic_3.jpg',
    'assets/images/banto_s/10/pic/pic_1.jpg',
    'assets/images/banto_s/10/pic/pic_2.jpg',
    'assets/images/banto_s/10/pic/pic_3.jpg',
    'assets/images/banto_s/11/pic/pic_1.jpg',
    'assets/images/banto_s/11/pic/pic_2.jpg',
    'assets/images/banto_s/11/pic/pic_3.jpg',
    'assets/images/banto_s/12/pic/pic_1.jpg',
    'assets/images/banto_s/12/pic/pic_2.jpg',
    'assets/images/banto_s/12/pic/pic_3.jpg',
  ];
  
  // 获取用户资料
  static Future<UserProfile> getUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_userProfileKey);
      
      if (profileJson != null) {
        final Map<String, dynamic> profileMap = json.decode(profileJson);
        return UserProfile.fromJson(profileMap);
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
    
    // 返回默认资料
    return UserProfile(
      name: _defaultName,
      signature: _defaultSignature,
      avatar: _defaultAvatar,
    );
  }
  
  // 保存用户资料
  static Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(_userProfileKey, profileJson);
      return true;
    } catch (e) {
      print('Error saving user profile: $e');
      return false;
    }
  }
  
  // 获取预设头像列表
  static List<String> getPresetAvatars() {
    return _presetAvatars;
  }
  
  // 清除用户资料（重置为默认）
  static Future<bool> clearUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userProfileKey);
      return true;
    } catch (e) {
      print('Error clearing user profile: $e');
      return false;
    }
  }
}

// 用户资料模型
class UserProfile {
  final String name;
  final String signature;
  final String avatar;
  
  UserProfile({
    required this.name,
    required this.signature,
    required this.avatar,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Darlene Beats',
      signature: json['signature'] ?? 'An ordinary perfume collector',
      avatar: json['avatar'] ?? 'assets/images/banto_s/1/pic/pic_1.jpg',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'signature': signature,
      'avatar': avatar,
    };
  }
  
  UserProfile copyWith({
    String? name,
    String? signature,
    String? avatar,
  }) {
    return UserProfile(
      name: name ?? this.name,
      signature: signature ?? this.signature,
      avatar: avatar ?? this.avatar,
    );
  }
} 