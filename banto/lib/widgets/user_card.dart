import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../models/user_model.dart';
import '../pages/user_detail_page.dart';
import '../services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../pages/subscriptions_page.dart';

class UserCard extends StatefulWidget {
  final UserModel user;
  final double width;
  final double height;
  final VoidCallback? onFavoriteChanged;
  final Function(UserModel)? onCardTap;

  const UserCard({
    super.key,
    required this.user,
    required this.width,
    required this.height,
    this.onFavoriteChanged,
    this.onCardTap,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with TickerProviderStateMixin {
  bool _isFavorite = false;
  bool _isLoading = false;
  bool _isVip = false;
  DateTime? _vipExpiry;
  bool _isDialogShowing = false;
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _favoriteAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));
    
    _checkFavoriteStatus();
    _loadVipStatus();
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FavoritesService.isFavorite(widget.user.userId);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  void _showVipRequiredDialog() {
    if (_isDialogShowing) return; // 防止重复弹窗
    
    setState(() {
      _isDialogShowing = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Banto Premium',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unlock unlimited favorites with Banto Premium!',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Unlimited browsing to discover works',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Unlimited consultation with AI advisors',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Unlimited modification of user avatars',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Like and collect your favorite users infinitely',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Ad-free experience',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogShowing = false;
                  });
                },
                child: Text(
                  'Later',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isDialogShowing = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionsPage(),
                      ),
                    ).then((_) {
                      // 用户从订阅页面返回后重新检查VIP状态
                      _loadVipStatus();
                    });
                  },
                  child: const Text(
                    'Get Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;
    
    // 检查VIP状态
    if (!_isVip) {
      _showVipRequiredDialog();
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await FavoritesService.toggleFavorite(widget.user);
      
      if (success && mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = false;
        });
        
        // 播放动画
        _favoriteController.forward().then((_) {
          _favoriteController.reverse();
        });
        
        // 震动反馈
        HapticFeedback.lightImpact();
        
        // 通知父组件
        widget.onFavoriteChanged?.call();
        
        // 显示提示
        _showFavoriteMessage(_isFavorite);
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
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

  void _onCardTap(BuildContext context) {
    if (widget.onCardTap != null) {
      widget.onCardTap!(widget.user);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailPage(user: widget.user),
        ),
      );
    }
  }

  Future<void> _loadVipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVip = prefs.getBool('isVip') ?? false;
      final expiryStr = prefs.getString('vipExpiry');
      _vipExpiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
      
      // 检查VIP是否过期
      if (_isVip && _vipExpiry != null && _vipExpiry!.isBefore(DateTime.now())) {
        _isVip = false;
        prefs.setBool('isVip', false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 调试信息
    print('UserCard - Loading user: ${widget.user.name}');
    print('UserCard - Background image path: ${widget.user.userIconBg}');
    print('UserCard - User icon path: ${widget.user.userIcon}');
    
    return GestureDetector(
      onTap: () => _onCardTap(context),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 背景图片
              Container(
                width: double.infinity,
                height: double.infinity,
                child: widget.user.userIconBg.isNotEmpty
                    ? Image.asset(
                        widget.user.userIconBg,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading background image: ${widget.user.userIconBg}');
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 50,
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
                            size: 50,
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
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
              // 收藏按钮
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: AnimatedBuilder(
                    animation: _favoriteAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _favoriteAnimation.value,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red.withOpacity(0.7),
                                    ),
                                  ),
                                )
                              : Icon(
                                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: _isFavorite ? Colors.red : Colors.grey[600],
                                  size: 22,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // 用户信息
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户头像和名字在同一行
                    Row(
                      children: [
                        // 用户头像
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.grey[300],
                            child: widget.user.userIcon.isNotEmpty
                                ? ClipOval(
                                    child: Image.asset(
                                      widget.user.userIcon,
                                      width: 26,
                                      height: 26,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Error loading user icon: ${widget.user.userIcon}');
                                        return const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 13,
                                        );
                                      },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 13,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 用户名
                        Expanded(
                          child: Text(
                            widget.user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 用户签名
                    Text(
                      widget.user.signa,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // 粉丝数
                    Text(
                      widget.user.followerCountFormatted + ' +',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
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
      ),
    );
  }
}