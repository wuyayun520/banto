import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../models/user_model.dart';
import '../pages/user_detail_page.dart';
import '../services/favorites_service.dart';

class UserListView extends StatefulWidget {
  final List<UserModel> users;
  final Function(UserModel)? onUserTap;
  
  const UserListView({
    super.key,
    required this.users,
    this.onUserTap,
  });

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final Map<String, bool> _favoriteStates = {};
  final Map<String, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStates();
  }

  Future<void> _initializeFavoriteStates() async {
    for (final user in widget.users) {
      final isFavorite = await FavoritesService.isFavorite(user.userId);
      if (mounted) {
        setState(() {
          _favoriteStates[user.userId] = isFavorite;
          _loadingStates[user.userId] = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(UserModel user) async {
    final userId = user.userId;
    
    if (_loadingStates[userId] == true) return;
    
    setState(() {
      _loadingStates[userId] = true;
    });
    
    try {
      final success = await FavoritesService.toggleFavorite(user);
      
      if (success && mounted) {
        setState(() {
          _favoriteStates[userId] = !(_favoriteStates[userId] ?? false);
          _loadingStates[userId] = false;
        });
        
        // 震动反馈
        HapticFeedback.lightImpact();
        
        // 显示提示
        _showFavoriteMessage(_favoriteStates[userId] ?? false);
      } else if (mounted) {
        setState(() {
          _loadingStates[userId] = false;
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        setState(() {
          _loadingStates[userId] = false;
        });
      }
    }
  }

  void _showFavoriteMessage(bool isFavorite) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: isFavorite ? const Color(0xFF4CAF50) : Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _onUserTap(BuildContext context, UserModel user) {
    if (widget.onUserTap != null) {
      widget.onUserTap!(user);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailPage(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No users found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isFavorite = _favoriteStates[user.userId] ?? false;
        final isLoading = _loadingStates[user.userId] ?? false;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _onUserTap(context, user),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // 背景图片
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: user.userIconBg.isNotEmpty
                          ? Image.asset(
                              user.userIconBg,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading background image: ${user.userIconBg}');
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                    ),
                    // 渐变遮罩
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // 收藏按钮
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _toggleFavorite(user),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red.withOpacity(0.7),
                                    ),
                                  ),
                                )
                              : Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey[600],
                                  size: 18,
                                ),
                        ),
                      ),
                    ),
                    // 用户信息
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          // 用户头像
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.grey[300],
                              child: user.userIcon.isNotEmpty
                                  ? ClipOval(
                                      child: Image.asset(
                                        user.userIcon,
                                        width: 46,
                                        height: 46,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading user icon: ${user.userIcon}');
                                          return const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                            size: 25,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 用户信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.signa,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.followerCountFormatted + ' +',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 