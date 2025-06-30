import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FollowService {
  static const String _followingKey = 'user_following';
  
  // 获取关注列表
  static Future<List<String>> getFollowing() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followingJson = prefs.getString(_followingKey);
      
      if (followingJson != null) {
        final List<dynamic> followingList = json.decode(followingJson);
        return followingList.cast<String>();
      }
    } catch (e) {
      print('Error loading following: $e');
    }
    
    return [];
  }
  
  // 关注用户
  static Future<bool> followUser(String userName) async {
    try {
      final following = await getFollowing();
      
      // 检查是否已经关注
      if (!following.contains(userName)) {
        following.add(userName);
        return await _saveFollowing(following);
      }
      
      return true; // 已经关注了
    } catch (e) {
      print('Error following user: $e');
      return false;
    }
  }
  
  // 取消关注用户
  static Future<bool> unfollowUser(String userName) async {
    try {
      final following = await getFollowing();
      following.remove(userName);
      return await _saveFollowing(following);
    } catch (e) {
      print('Error unfollowing user: $e');
      return false;
    }
  }
  
  // 检查是否已关注
  static Future<bool> isFollowing(String userName) async {
    try {
      final following = await getFollowing();
      return following.contains(userName);
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }
  
  // 切换关注状态
  static Future<bool> toggleFollow(String userName) async {
    try {
      final isCurrentlyFollowing = await isFollowing(userName);
      
      if (isCurrentlyFollowing) {
        return await unfollowUser(userName);
      } else {
        return await followUser(userName);
      }
    } catch (e) {
      print('Error toggling follow: $e');
      return false;
    }
  }
  
  // 获取关注数量
  static Future<int> getFollowingCount() async {
    try {
      final following = await getFollowing();
      return following.length;
    } catch (e) {
      print('Error getting following count: $e');
      return 0;
    }
  }
  
  // 清空关注
  static Future<bool> clearFollowing() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_followingKey);
      return true;
    } catch (e) {
      print('Error clearing following: $e');
      return false;
    }
  }
  
  // 保存关注列表到本地
  static Future<bool> _saveFollowing(List<String> following) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final followingJson = json.encode(following);
      await prefs.setString(_followingKey, followingJson);
      return true;
    } catch (e) {
      print('Error saving following: $e');
      return false;
    }
  }
} 