import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../pages/user_detail_page.dart';
import 'user_card.dart';

class UserCardStack extends StatefulWidget {
  final List<UserModel> users;
  final double width;
  final double height;
  final Function(UserModel)? onCardTap;

  const UserCardStack({
    super.key,
    required this.users,
    required this.width,
    required this.height,
    this.onCardTap,
  });

  @override
  State<UserCardStack> createState() => _UserCardStackState();
}

class _UserCardStackState extends State<UserCardStack>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.users.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    
    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(2.0, 0.0),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // 添加震动动画控制器
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _swipeCard() {
    if (_currentIndex < widget.users.length - 1) {
      _controllers[_currentIndex].forward().then((_) {
        setState(() {
          _currentIndex++;
        });
      });
    }
  }

  void _handleSwipeAttempt() {
    // 检查是否还有更多卡片可以滑动
    if (_currentIndex < widget.users.length - 1) {
      _swipeCard();
    } else {
      // 已经是最后一张卡片，显示提示并震动
      _showNoMoreCardsHint();
    }
  }

  void _showNoMoreCardsHint() {
    // 触发震动反馈
    HapticFeedback.lightImpact();
    
    // 播放震动动画
    _shakeController.forward().then((_) {
      _shakeController.reset();
    });
    
    // 显示提示信息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'No more profiles to show',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          for (int i = widget.users.length - 1; i >= 0; i--)
            if (i >= _currentIndex)
              AnimatedBuilder(
                animation: Listenable.merge([_animations[i], _shakeAnimation]),
                builder: (context, child) {
                  // 计算震动偏移量（仅对当前顶部卡片应用）
                  double shakeOffset = 0.0;
                  if (i == _currentIndex) {
                    shakeOffset = _shakeAnimation.value * 8.0 * 
                        (1.0 - 2.0 * (_shakeAnimation.value % 0.5).abs());
                  }
                  
                  return Transform.translate(
                    offset: _animations[i].value * widget.width + Offset(shakeOffset, 0),
                    child: Positioned(
                      left: (i - _currentIndex) * 8.0,
                      top: (i - _currentIndex) * 8.0,
                      child: GestureDetector(
                        onPanEnd: (details) {
                          // 只有向右滑动且速度足够快时才触发
                          if (details.velocity.pixelsPerSecond.dx > 300) {
                            _handleSwipeAttempt();
                          }
                        },
                        child: Transform.scale(
                          scale: 1.0 - (i - _currentIndex) * 0.05,
                          child: UserCard(
                            user: widget.users[i],
                            width: widget.width,
                            height: widget.height,
                            onCardTap: widget.onCardTap,
                            onFavoriteChanged: () {
                              // 收藏状态改变时的回调，这里可以添加额外的逻辑
                              print('Favorite status changed for user: ${widget.users[i].name}');
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          // 添加底部指示器显示当前进度
          if (widget.users.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.users.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= _currentIndex 
                          ? Colors.white.withOpacity(0.9)
                          : Colors.white.withOpacity(0.3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 