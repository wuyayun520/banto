import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_colors.dart';
import '../post_detail_page.dart';
import '../subscriptions_page.dart';

class Tab2Page extends StatefulWidget {
  const Tab2Page({super.key});

  @override
  State<Tab2Page> createState() => _Tab2PageState();
}

class _Tab2PageState extends State<Tab2Page> {
  List<PostItem> allPosts = [];
  List<PostItem> visiblePosts = [];
  List<String> reportedPostIds = [];
  bool isLoading = true;
  bool _isVip = false;
  DateTime? _vipExpiry;
  final ScrollController _scrollController = ScrollController();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _loadReportedPosts();
    _loadPostData();
    _loadVipStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _loadReportedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reportedPostIds = prefs.getStringList('reported_posts') ?? [];
    });
  }

  Future<void> _loadPostData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/bango_j.json');
      final data = json.decode(response);
      
      List<PostItem> posts = [];
      for (var userData in data['allData']) {
        String userName = userData['name'];
        String userIcon = userData['userIcon'];
        
        for (var post in userData['post']) {
          posts.add(PostItem(
            postId: post['postId'],
            postMsg: post['postmsg'],
            isVideo: post['isVideo'] == '1',
            playVideo: post['playVideo'],
            postPic1: post['post_pic_1'],
            postPic2: post['post_pic_2'],
            postPic3: post['post_pic_3'],
            userName: userName,
            userIcon: userIcon,
          ));
        }
      }
      
      setState(() {
        allPosts = posts;
        _filterVisiblePosts();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterVisiblePosts() {
    visiblePosts = allPosts.where((post) => !reportedPostIds.contains(post.postId)).toList();
  }

  void _onPostReported(String postId) {
    setState(() {
      reportedPostIds.add(postId);
      _filterVisiblePosts();
    });
  }

  bool _onScrollNotification(ScrollNotification scrollNotification) {
    // 如果弹窗正在显示，阻止所有滑动
    if (_isDialogShowing) {
      return true;
    }
    
    if (scrollNotification is ScrollStartNotification) {
      // 滑动开始时检查VIP状态
      if (!_isVip) {
        _showVipRequiredDialog();
        return true; // 阻止滑动
      }
    }
    return false; // 允许滑动继续
  }

  void _showVipRequiredDialog() {
    if (_isDialogShowing) return; // 防止重复弹窗
    
    setState(() {
      _isDialogShowing = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54, // 增强背景遮罩
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // 禁止返回键关闭
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
                    Icons.local_bar,
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
                  'Unlock unlimited browsing with Banto Premium!',
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
                          const Text(
                            'Unlimited Browse discovery',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
                          const Text(
                            'Ad-free experience',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.allModulesBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 滚动内容 - 添加滑动监听
          NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  // Discover文字图片
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/banto_post_discover.png',
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Banner图片
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Image.asset(
                      'assets/images/banto_post_banner.png',
                      height: 140,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  // VIP状态提示 (如果不是VIP)
                  if (!_isVip)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.local_bar,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upgrade to Premium',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Unlock unlimited browsing & more',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SubscriptionsPage(),
                                ),
                              ).then((_) {
                                _loadVipStatus();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Get Premium',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // 帖子网格
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: visiblePosts.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            post: visiblePosts[index],
                            onPostReported: _onPostReported,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostItem {
  final String postId;
  final String postMsg;
  final bool isVideo;
  final String? playVideo;
  final String? postPic1;
  final String? postPic2;
  final String? postPic3;
  final String userName;
  final String userIcon;

  PostItem({
    required this.postId,
    required this.postMsg,
    required this.isVideo,
    this.playVideo,
    this.postPic1,
    this.postPic2,
    this.postPic3,
    required this.userName,
    required this.userIcon,
  });
}

class PostCard extends StatelessWidget {
  final PostItem post;
  final Function(String) onPostReported;

  const PostCard({super.key, required this.post, required this.onPostReported});

  List<String> _getPostImages() {
    List<String> images = [];
    if (post.postPic1 != null && post.postPic1!.isNotEmpty) {
      images.add(post.postPic1!);
    }
    if (post.postPic2 != null && post.postPic2!.isNotEmpty) {
      images.add(post.postPic2!);
    }
    if (post.postPic3 != null && post.postPic3!.isNotEmpty) {
      images.add(post.postPic3!);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> postImages = _getPostImages();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(
                post: post,
                onPostReported: onPostReported,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 媒体内容区域
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      post.isVideo
                          ? VideoThumbnail(videoPath: post.playVideo ?? '')
                          : _buildImageContent(postImages),
                      // 多张图片指示器
                      if (!post.isVideo && postImages.length > 1)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${postImages.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // 文字内容区域
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户信息
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        child: ClipOval(
                          child: Image.asset(
                            post.userIcon,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 12,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          post.userName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 帖子内容
                  Text(
                    post.postMsg,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(List<String> postImages) {
    String? imageToShow;
    
    if (postImages.isNotEmpty) {
      imageToShow = postImages[0]; // 显示第一张图片
    }

    if (imageToShow == null) {
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
    }

    return Image.asset(
      imageToShow,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
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
    );
  }
}

// 视频缩略图组件
class VideoThumbnail extends StatefulWidget {
  final String videoPath;

  const VideoThumbnail({super.key, required this.videoPath});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath.isNotEmpty) {
      _initializeVideo();
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            // 暂停视频以显示首帧
            _controller!.pause();
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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || widget.videoPath.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: Center(
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
                'Video unavailable',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      );
    }

    return Stack(
      children: [
        // 视频首帧作为背景
        Container(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          ),
        ),
        // 播放按钮覆盖层
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        // 视频标识
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: 12,
                ),
                SizedBox(width: 2),
                Text(
                  'VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 