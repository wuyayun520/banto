import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class FavoritesService {
  static const String _favoritesKey = 'user_favorites';
  
  // 获取收藏列表
  static Future<List<UserModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = json.decode(favoritesJson);
        return favoritesList.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
    
    return [];
  }
  
  // 添加到收藏
  static Future<bool> addToFavorites(UserModel user) async {
    try {
      final favorites = await getFavorites();
      
      // 检查是否已经收藏
      if (!favorites.any((fav) => fav.userId == user.userId)) {
        favorites.add(user);
        return await _saveFavorites(favorites);
      }
      
      return true; // 已经收藏了
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }
  
  // 从收藏中移除
  static Future<bool> removeFromFavorites(String userId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((user) => user.userId == userId);
      return await _saveFavorites(favorites);
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }
  
  // 检查是否已收藏
  static Future<bool> isFavorite(String userId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((user) => user.userId == userId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }
  
  // 切换收藏状态
  static Future<bool> toggleFavorite(UserModel user) async {
    try {
      final isCurrentlyFavorite = await isFavorite(user.userId);
      
      if (isCurrentlyFavorite) {
        return await removeFromFavorites(user.userId);
      } else {
        return await addToFavorites(user);
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
  
  // 获取收藏数量
  static Future<int> getFavoritesCount() async {
    try {
      final favorites = await getFavorites();
      return favorites.length;
    } catch (e) {
      print('Error getting favorites count: $e');
      return 0;
    }
  }
  
  // 清空收藏
  static Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      return true;
    } catch (e) {
      print('Error clearing favorites: $e');
      return false;
    }
  }
  
  // 保存收藏列表到本地
  static Future<bool> _saveFavorites(List<UserModel> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favorites.map((user) => user.toJson()).toList());
      await prefs.setString(_favoritesKey, favoritesJson);
      return true;
    } catch (e) {
      print('Error saving favorites: $e');
      return false;
    }
  }
} 