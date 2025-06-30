import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../constants/app_colors.dart';
import 'dart:async';

class VideoCallPage extends StatefulWidget {
  final UserModel user;
  
  const VideoCallPage({
    super.key,
    required this.user,
  });

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage>
    with TickerProviderStateMixin {
  Timer? _callTimer;
  int _callDuration = 0;
  bool _isCallActive = true;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    _initializeWaveAnimation();
  }

  void _initializeWaveAnimation() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
    _waveController.repeat();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
      
      // 20秒后自动挂断
      if (_callDuration >= 20) {
        _endCallWithOfflineMessage();
      }
    });
  }

  void _endCallWithOfflineMessage() {
    _callTimer?.cancel();
    _waveController.stop();
    setState(() {
      _isCallActive = false;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF6B6B),
                    const Color(0xFFFF5252),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_disabled_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Call Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'User is offline. Please try again later.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B6B),
                  const Color(0xFFFF5252),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭弹窗
                Navigator.pop(context); // 返回聊天页面
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }

  void _endCall() {
    _callTimer?.cancel();
    _waveController.stop();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 用户背景图片
          Positioned.fill(
            child: Image.asset(
              widget.user.chatBg,
              fit: BoxFit.cover,
            ),
          ),
          // 渐变遮罩
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          // 左上角用户信息
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 24,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(widget.user.usericon),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.user.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 中间提示文字
          Positioned(
            bottom: 200,
            left: 24,
            right: 24,
            child: Text(
              'Invite you to a video call...',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // 底部挂断按钮带声波动画
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 声波动画 - 外层
                      Container(
                        width: 120 + (_waveAnimation.value * 40),
                        height: 120 + (_waveAnimation.value * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF6B6B).withOpacity(0.3 * (1 - _waveAnimation.value)),
                            width: 2,
                          ),
                        ),
                      ),
                      // 声波动画 - 中层
                      Container(
                        width: 100 + (_waveAnimation.value * 20),
                        height: 100 + (_waveAnimation.value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF6B6B).withOpacity(0.5 * (1 - _waveAnimation.value)),
                            width: 2,
                          ),
                        ),
                      ),
                      // 挂断按钮
                      GestureDetector(
                        onTap: _endCall,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF6B6B),
                                const Color(0xFFFF5252),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B6B).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.call_end_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 