import 'package:flutter/material.dart';
import 'dart:math';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../constants/app_constants.dart';
import 'chat_page.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel user;
  
  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadBlockedStatus();
  }

  // 加载拉黑状态
  Future<void> _loadBlockedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUsersJson = prefs.getString('blocked_users') ?? '[]';
    final List<dynamic> blockedUsers = json.decode(blockedUsersJson);
    
    setState(() {
      _isBlocked = blockedUsers.contains(widget.user.userId);
    });
  }

  // 保存拉黑状态
  Future<void> _saveBlockedStatus(bool isBlocked) async {
    final prefs = await SharedPreferences.getInstance();
    final blockedUsersJson = prefs.getString('blocked_users') ?? '[]';
    List<dynamic> blockedUsers = json.decode(blockedUsersJson);
    
    if (isBlocked) {
      if (!blockedUsers.contains(widget.user.userId)) {
        blockedUsers.add(widget.user.userId);
      }
    } else {
      blockedUsers.remove(widget.user.userId);
    }
    
    await prefs.setString('blocked_users', json.encode(blockedUsers));
    setState(() {
      _isBlocked = isBlocked;
    });
  }

  // 显示更多选项菜单
  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 拖拽指示器
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 标题
                  Text(
                    'More Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 拉黑/解除拉黑选项
                  _buildOptionItem(
                    icon: _isBlocked ? Icons.person_add_rounded : Icons.block_rounded,
                    title: _isBlocked ? 'Unblock User' : 'Block User',
                    subtitle: _isBlocked 
                        ? 'Restore normal interaction with this user'
                        : 'Block this user and hide their content',
                    color: _isBlocked ? Colors.green : Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      _showBlockConfirmDialog();
                    },
                  ),
                  const SizedBox(height: 16),
                  // 举报选项
                  _buildOptionItem(
                    icon: Icons.report_rounded,
                    title: 'Report User',
                    subtitle: 'Report inappropriate behavior or content',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showReportDialog();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 构建选项项目
  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // 显示拉黑确认对话框
  void _showBlockConfirmDialog() {
    showDialog(
      context: context,
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
                color: (_isBlocked ? Colors.green : Colors.orange).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isBlocked ? Icons.person_add_rounded : Icons.block_rounded,
                color: _isBlocked ? Colors.green : Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _isBlocked ? 'Unblock User' : 'Block User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          _isBlocked 
              ? 'Are you sure you want to unblock ${widget.user.name}? You will be able to see their content and interact with them again.'
              : 'Are you sure you want to block ${widget.user.name}? You will not be able to chat with them or see their content.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _isBlocked ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (_isBlocked ? Colors.green : Colors.orange).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveBlockedStatus(!_isBlocked);
                _showActionSuccessDialog(_isBlocked ? 'User unblocked successfully!' : 'User blocked successfully!');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isBlocked ? 'Unblock' : 'Block',
                style: const TextStyle(
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

  // 显示举报对话框
  void _showReportDialog() {
    showDialog(
      context: context,
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
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.report_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Report User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to report ${widget.user.name}? This will help us maintain a safe community environment.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showActionSuccessDialog('Report submitted successfully! We will review it shortly.');
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
                'Report',
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

  // 显示操作成功对话框
  void _showActionSuccessDialog(String message) {
    showDialog(
      context: context,
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
                    const Color(0xFF4CAF50),
                    const Color(0xFF45A049),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4CAF50),
                  const Color(0xFF45A049),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
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

  List<String> _getAllUserImages() {
    List<String> images = [];
    
    // 添加用户头像
    if (widget.user.userIcon.isNotEmpty) {
      images.add(widget.user.userIcon);
    }
    
    // 添加用户背景图片
    if (widget.user.userIconBg.isNotEmpty) {
      images.add(widget.user.userIconBg);
    }
    
    // 添加帖子中的图片
    for (var post in widget.user.post) {
      if (post.postPic1 != null && post.postPic1!.isNotEmpty) {
        images.add(post.postPic1!);
      }
      if (post.postPic2 != null && post.postPic2!.isNotEmpty) {
        images.add(post.postPic2!);
      }
      if (post.postPic3 != null && post.postPic3!.isNotEmpty) {
        images.add(post.postPic3!);
      }
    }
    
    return images;
  }

  void _showImagePreview(String imagePath, int initialIndex, List<String> allImages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePreviewDialog(
          imagePath: imagePath,
          initialIndex: initialIndex,
          allImages: allImages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> userImages = _getAllUserImages();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.allModulesBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 自定义AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      onPressed: _showMoreOptions,
                    ),
                  ],
                ),
              ),
              // 页面内容
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // 用户头像
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: widget.user.userIcon.isNotEmpty
                            ? ClipOval(
                                child: Image.asset(
                                  widget.user.userIcon,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 60,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 60,
                              ),
                      ),
                      const SizedBox(height: 20),
                      // 用户名
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 用户背景介绍
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          widget.user.introduction,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // 统计数据
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(widget.user.followerCountFormatted, 'follower'),
                          _buildStatItem(widget.user.followingCountFormatted, 'following'),
                          _buildStatItem(widget.user.likeCountFormatted, 'like'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // 用户所有图片展示
                      if (userImages.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemCount: userImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _showImagePreview(userImages[index], index, userImages),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[300],
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      userImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 30),
                      // 按钮区域
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey[200]!, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.grid_view_rounded,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.user.post.length}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 聊天按钮 - 拉黑时隐藏
                            if (!_isBlocked)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(user: widget.user),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF7DE8FD), Color(0xFF5BC0DE)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7DE8FD).withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Chat',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // 拉黑状态提示
                            if (_isBlocked)
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.block_rounded,
                                        color: Colors.grey[600],
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Blocked',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // 帖子内容区域
                      if (widget.user.post.isNotEmpty)
                        ...widget.user.post.map((post) => Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 帖子头部
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    child: widget.user.userIcon.isNotEmpty
                                        ? ClipOval(
                                            child: Image.asset(
                                              widget.user.userIcon,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                  size: 20,
                                                );
                                              },
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // 帖子内容
                              if (post.postmsg.isNotEmpty)
                                Text(
                                  post.postmsg,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              if (post.postmsg.isNotEmpty)
                                const SizedBox(height: 16),
                              // 根据isVideo字段展示视频或图片
                              if (post.isVideo == '1' && post.playVideo != null && post.playVideo!.isNotEmpty)
                                // 展示视频
                                VideoPlayerWidget(videoPath: post.playVideo!)
                              else if (post.isVideo == '0')
                                // 展示图片
                                _buildPostImages(post, userImages),
                              const SizedBox(height: 16),
                              // 帖子底部
                              Row(
                                children: [
                                  
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${Random().nextInt(500) + 100}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.grey[600],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${Random().nextInt(100) + 10}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )).toList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPostImages(PostModel post, List<String> userImages) {
    List<String> postImages = [];
    if (post.postPic1 != null && post.postPic1!.isNotEmpty) {
      postImages.add(post.postPic1!);
    }
    if (post.postPic2 != null && post.postPic2!.isNotEmpty) {
      postImages.add(post.postPic2!);
    }
    if (post.postPic3 != null && post.postPic3!.isNotEmpty) {
      postImages.add(post.postPic3!);
    }

    if (postImages.isEmpty) return Container();

    if (postImages.length == 1) {
      return GestureDetector(
        onTap: () => _showImagePreview(postImages[0], userImages.indexOf(postImages[0]), userImages),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              postImages[0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else if (postImages.length == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showImagePreview(postImages[0], userImages.indexOf(postImages[0]), userImages),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    postImages[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _showImagePreview(postImages[1], userImages.indexOf(postImages[1]), userImages),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    postImages[1],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // 3张图片的网格布局
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: postImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showImagePreview(postImages[index], userImages.indexOf(postImages[index]), userImages),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  postImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

// 图片预览对话框组件
class ImagePreviewDialog extends StatefulWidget {
  final String imagePath;
  final int initialIndex;
  final List<String> allImages;

  const ImagePreviewDialog({
    super.key,
    required this.imagePath,
    required this.initialIndex,
    required this.allImages,
  });

  @override
  State<ImagePreviewDialog> createState() => _ImagePreviewDialogState();
}

class _ImagePreviewDialogState extends State<ImagePreviewDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.9),
        child: Stack(
          children: [
            // 图片展示区域
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.allImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          widget.allImages[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            // 页面指示器
            if (widget.allImages.length > 1)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.allImages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentIndex
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 视频播放器组件
class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            // 暂停视频以显示首帧作为封面
            _controller.pause();
          });
        }
      }).catchError((error) {
        print('Video initialization error: $error');
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
    } catch (e) {
      print('Video controller creation error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                color: Colors.grey,
                size: 40,
              ),
              SizedBox(height: 8),
              Text(
                'Video not available',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 视频播放器，显示首帧作为封面
            Container(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            // 播放/暂停按钮覆盖层
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 视频时长显示（可选）
            if (_controller.value.duration.inSeconds > 0)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDuration(_controller.value.duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
} 