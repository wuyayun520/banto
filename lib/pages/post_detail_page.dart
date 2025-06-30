import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import '../constants/app_constants.dart';
import '../services/follow_service.dart';
import 'tabs/tab2_page.dart';

// 评论数据模型
class CommentItem {
  final String userName;
  final String userAvatar;
  final String comment;
  final String time;

  CommentItem({
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userAvatar': userAvatar,
      'comment': comment,
      'time': time,
    };
  }

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      comment: json['comment'],
      time: json['time'],
    );
  }
}

class PostDetailPage extends StatefulWidget {
  final PostItem post;
  final Function(String)? onPostReported; // Callback for when post is reported

  const PostDetailPage({
    super.key,
    required this.post,
    this.onPostReported,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PageController? _pageController;
  int _currentImageIndex = 0;
  List<CommentItem> _comments = [];
  bool _isLoadingComments = true;
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;
  bool _isFollowing = false;
  bool _isFollowLoading = false;
  bool _isLiked = false;
  bool _isLikeLoading = false;
  int _likeCount = 0;

  // Perfume-related comment templates
  static const List<String> _perfumeComments = [
    "This fragrance has an amazing opening!",
    "The combination of rose and jasmine is perfect",
    "How's the longevity? Does it last long?",
    "What season is this perfume suitable for?",
    "The packaging design is so beautiful and elegant",
    "It smells very layered, I love it",
    "This brand's perfumes are always excellent",
    "What's the price? Is it good value for money?",
    "Is it suitable for daily wear or special occasions?",
    "How does it compare to other similar fragrances?",
    "The scent is very unique and personal",
    "The bottle design is also very artistic",
    "This scent reminds me of spring",
    "Very gentle fragrance, very healing",
    "Is it suitable for young people?",
    "Does this perfume have any special story?",
    "Smells very high-end, great quality",
    "Is it too strong? Light or intense?",
    "How's the projection of this perfume?",
    "The packaging is exquisite, perfect for gifts",
    "The scent is very fresh, not overwhelming",
    "I've always trusted this brand",
    "What skin type is it suitable for?",
    "Does this perfume have a sample size?",
    "The scent is very distinctive and recognizable",
    "What's the inspiration behind this fragrance?",
    "Very suitable for professional women",
    "Rich fragrance layers with many changes",
    "This price point is very reasonable",
    "Very satisfied with both packaging and scent",
    "The dry down is absolutely gorgeous",
    "Perfect for date nights!",
    "This is my signature scent now",
    "The sillage is just right",
    "Love the floral heart notes",
    "The woody base is so sophisticated",
    "Great for both day and night wear",
    "This bottle looks stunning on my dresser",
    "The atomizer spray is perfect",
    "Compliments every time I wear it"
  ];

  static const List<String> _userNames = [
    "PerfumeLover", "ScentAddict", "FragranceQueen", "RoseGarden", "JasmineDream", 
    "PerfumeExpert", "ScentCollector", "FragranceGirl", "Lavender", "CitrusSummer",
    "PerfumeMaster", "ScentNotes", "FragranceEnthusiast", "ScentHunter", "PerfumeFairy",
    "FragranceStudio", "PerfumeReviewer", "AromaExpert", "ScentAnalyst", "FragranceBlogger",
    "AromaResearcher", "PerfumeArtist", "ScentConnoisseur", "FragranceAddict", "ScentLover",
    "PerfumePassion", "FragranceJourney", "ScentExplorer", "PerfumeWisdom", "FragranceVibes"
  ];

  @override
  void initState() {
    super.initState();
    if (!widget.post.isVideo) {
      _pageController = PageController();
    }
    _loadComments();
    _checkFollowStatus();
    _loadLikeStatus();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final commentsKey = 'comments_${widget.post.postId}';
    final commentsJson = prefs.getString(commentsKey);
    
    if (commentsJson != null) {
      // Load existing comments
      final List<dynamic> commentsList = json.decode(commentsJson);
      setState(() {
        _comments = commentsList.map((item) => CommentItem.fromJson(item)).toList();
        _isLoadingComments = false;
      });
    } else {
      // Generate new comments
      await _generateComments();
    }
  }

  Future<void> _generateComments() async {
    final random = Random();
    final commentCount = random.nextInt(10) + 1; // 1-10 comments
    List<CommentItem> newComments = [];
    
    // Generate random times (within last 24 hours)
    List<String> generateRandomTimes(int count) {
      List<String> times = [];
      for (int i = 0; i < count; i++) {
        final randomHour = random.nextInt(24);
        final randomMinute = random.nextInt(60);
        times.add('${randomHour.toString().padLeft(2, '0')}:${randomMinute.toString().padLeft(2, '0')}');
      }
      return times;
    }

    final times = generateRandomTimes(commentCount);
    
    for (int i = 0; i < commentCount; i++) {
      // Randomly select user name
      final userName = _userNames[random.nextInt(_userNames.length)];
      
      // Randomly select avatar (using existing user avatars)
      final avatarPaths = [
        'assets/images/banto_s/1/pic/pic_1.jpg',
        'assets/images/banto_s/2/pic/pic_1.jpg',
        'assets/images/banto_s/3/pic/pic_1.jpg',
        'assets/images/banto_s/4/pic/pic_1.jpg',
        'assets/images/banto_s/5/pic/pic_1.jpg',
        'assets/images/banto_s/6/pic/pic_1.jpg',
        'assets/images/banto_s/7/pic/pic_1.jpg',
        'assets/images/banto_s/8/pic/pic_1.jpg',
        'assets/images/banto_s/9/pic/pic_1.jpg',
        'assets/images/banto_s/10/pic/pic_1.jpg',
      ];
      final userAvatar = avatarPaths[random.nextInt(avatarPaths.length)];
      
      // Randomly select comment content
      final comment = _perfumeComments[random.nextInt(_perfumeComments.length)];
      
      newComments.add(CommentItem(
        userName: userName,
        userAvatar: userAvatar,
        comment: comment,
        time: times[i],
      ));
    }
    
    // Save comments to local storage
    final prefs = await SharedPreferences.getInstance();
    final commentsKey = 'comments_${widget.post.postId}';
    final commentsJson = json.encode(newComments.map((item) => item.toJson()).toList());
    await prefs.setString(commentsKey, commentsJson);
    
    setState(() {
      _comments = newComments;
      _isLoadingComments = false;
    });
  }

  Future<void> _postComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() {
      _isPostingComment = true;
    });

    try {
      // Get current time
      final now = DateTime.now();
      final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      // Create new comment (user comment)
      final newComment = CommentItem(
        userName: "You", // User's own comment
        userAvatar: "assets/images/banto_s/1/pic/pic_1.jpg", // Can use default avatar or user avatar
        comment: commentText,
        time: timeString,
      );

      // Add new comment to the front of the list
      final updatedComments = [newComment, ..._comments];

      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      final commentsKey = 'comments_${widget.post.postId}';
      final commentsJson = json.encode(updatedComments.map((item) => item.toJson()).toList());
      await prefs.setString(commentsKey, commentsJson);

      // Update UI
      setState(() {
        _comments = updatedComments;
        _commentController.clear();
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment posted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to post comment. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      setState(() {
        _isPostingComment = false;
      });
    }
  }

  // Report post functionality
  Future<void> _showReportDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Post'),
          content: const Text('Are you sure you want to report this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reportPost();
              },
              child: const Text(
                'Report',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reportPost() async {
    try {
      // Save reported post ID to local storage
      final prefs = await SharedPreferences.getInstance();
      List<String> reportedPosts = prefs.getStringList('reported_posts') ?? [];
      if (!reportedPosts.contains(widget.post.postId)) {
        reportedPosts.add(widget.post.postId);
        await prefs.setStringList('reported_posts', reportedPosts);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post reported successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Call the callback to notify parent widget
        if (widget.onPostReported != null) {
          widget.onPostReported!(widget.post.postId);
        }

        // Exit detail page after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to report post. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // Report comment functionality
  Future<void> _showReportCommentDialog(String userName, String comment) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.report_outlined,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Report Comment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to report this comment from $userName?',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"$comment"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reportComment(userName, comment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Report',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reportComment(String userName, String comment) async {
    try {
      // Save reported comment to local storage
      final prefs = await SharedPreferences.getInstance();
      List<String> reportedComments = prefs.getStringList('reported_comments') ?? [];
      String commentKey = '${widget.post.postId}_${userName}_${comment.hashCode}';
      
      if (!reportedComments.contains(commentKey)) {
        reportedComments.add(commentKey);
        await prefs.setStringList('reported_comments', reportedComments);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Comment reported successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Failed to report comment. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  // Follow functionality
  Future<void> _checkFollowStatus() async {
    try {
      final isFollowing = await FollowService.isFollowing(widget.post.userName);
      if (mounted) {
        setState(() {
          _isFollowing = isFollowing;
        });
      }
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    if (_isFollowLoading) return;

    setState(() {
      _isFollowLoading = true;
    });

    try {
      final success = await FollowService.toggleFollow(widget.post.userName);
      
      if (success && mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
          _isFollowLoading = false;
        });
        
        // 震动反馈
        HapticFeedback.lightImpact();
        
        // 显示提示
        _showFollowMessage(_isFollowing);
      } else if (mounted) {
        setState(() {
          _isFollowLoading = false;
        });
      }
    } catch (e) {
      print('Error toggling follow: $e');
      if (mounted) {
        setState(() {
          _isFollowLoading = false;
        });
      }
    }
  }

  void _showFollowMessage(bool isFollowing) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFollowing ? Icons.person_add : Icons.person_remove,
                color: isFollowing ? Colors.green : Colors.orange,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(isFollowing ? 'Followed ${widget.post.userName}!' : 'Unfollowed ${widget.post.userName}!'),
          ],
        ),
        backgroundColor: isFollowing ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Like functionality
  Future<void> _loadLikeStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likeKey = 'post_like_${widget.post.postId}';
      final likeCountKey = 'post_like_count_${widget.post.postId}';
      
      // Check if user has liked this post
      final isLiked = prefs.getBool(likeKey) ?? false;
      
      // Get like count, if not exists, generate random count
      int likeCount = prefs.getInt(likeCountKey) ?? 0;
      if (likeCount == 0) {
        // Generate random like count between 100-1000
        final random = Random();
        likeCount = random.nextInt(901) + 100; // 100 to 1000
        await prefs.setInt(likeCountKey, likeCount);
      }
      
      if (mounted) {
        setState(() {
          _isLiked = isLiked;
          _likeCount = likeCount;
        });
      }
    } catch (e) {
      print('Error loading like status: $e');
      // Set default values if error occurs
      if (mounted) {
        setState(() {
          _isLiked = false;
          _likeCount = Random().nextInt(901) + 100;
        });
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_isLikeLoading) return;

    setState(() {
      _isLikeLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final likeKey = 'post_like_${widget.post.postId}';
      final likeCountKey = 'post_like_count_${widget.post.postId}';
      
      final newLikedStatus = !_isLiked;
      int newLikeCount = _likeCount;
      
      if (newLikedStatus) {
        // User is liking the post
        newLikeCount += 1;
      } else {
        // User is unliking the post
        newLikeCount = max(0, newLikeCount - 1);
      }
      
      // Save to local storage
      await prefs.setBool(likeKey, newLikedStatus);
      await prefs.setInt(likeCountKey, newLikeCount);
      
      if (mounted) {
        setState(() {
          _isLiked = newLikedStatus;
          _likeCount = newLikeCount;
          _isLikeLoading = false;
        });
        
        // 震动反馈
        HapticFeedback.lightImpact();
        
        // 显示提示
        _showLikeMessage(newLikedStatus);
      }
    } catch (e) {
      print('Error toggling like: $e');
      if (mounted) {
        setState(() {
          _isLikeLoading = false;
        });
      }
    }
  }

  void _showLikeMessage(bool isLiked) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(isLiked ? 'Post liked!' : 'Post unliked!'),
          ],
        ),
        backgroundColor: isLiked ? Colors.red : Colors.grey,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  List<String> _getPostImages() {
    List<String> images = [];
    if (widget.post.postPic1 != null && widget.post.postPic1!.isNotEmpty) {
      images.add(widget.post.postPic1!);
    }
    if (widget.post.postPic2 != null && widget.post.postPic2!.isNotEmpty) {
      images.add(widget.post.postPic2!);
    }
    if (widget.post.postPic3 != null && widget.post.postPic3!.isNotEmpty) {
      images.add(widget.post.postPic3!);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> postImages = _getPostImages();

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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    // 用户头像
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: ClipOval(
                        child: Image.asset(
                          widget.post.userIcon,
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 用户名
                    Expanded(
                      child: Text(
                        widget.post.userName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Follow按钮
                    GestureDetector(
                      onTap: _isFollowLoading ? null : _toggleFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isFollowing ? Colors.grey[300] : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          border: _isFollowing ? Border.all(color: Colors.grey[400]!, width: 1) : null,
                        ),
                        child: _isFollowLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isFollowing ? Icons.person_remove : Icons.person_add,
                                    color: _isFollowing ? Colors.grey[700] : Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isFollowing ? 'Following' : 'Follow',
                                    style: TextStyle(
                                      color: _isFollowing ? Colors.grey[700] : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.report, color: Colors.red),
                      onPressed: _showReportDialog,
                      tooltip: 'Report Post',
                    ),
                  ],
                ),
              ),
              // 主要内容区域 - 可滚动
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 媒体内容区域
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.post.isVideo
                              ? _buildVideoContent()
                              : _buildImageContent(postImages),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 帖子文字内容
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.post.postMsg,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 互动按钮区域
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildActionButton(
                              icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                              label: _likeCount.toString(),
                              onTap: _isLikeLoading ? () {} : _toggleLike,
                              isActive: _isLiked,
                              isLoading: _isLikeLoading,
                            ),
                            const SizedBox(width: 20),
                            _buildActionButton(
                              icon: Icons.chat_bubble_outline,
                              label: '${_comments.length}',
                              onTap: () {},
                              isActive: false,
                              isLoading: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Comments section
                      _buildCommentsSection(),
                      const SizedBox(height: 80), // Leave space for bottom input box
                    ],
                  ),
                ),
              ),
              // Fixed comment input box at bottom
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Say something...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _postComment(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isPostingComment ? null : _postComment,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isPostingComment ? Colors.grey : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: _isPostingComment
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
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

  Widget _buildVideoContent() {
    return GestureDetector(
      onTap: () {
        // 跳转到视频播放页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(
              videoPath: widget.post.playVideo ?? '',
              post: widget.post,
            ),
          ),
        );
      },
      child: Container(
        height: 400,
        child: VideoThumbnailLarge(
          videoPath: widget.post.playVideo ?? '',
        ),
      ),
    );
  }

  Widget _buildImageContent(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 400,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image,
            color: Colors.grey,
            size: 60,
          ),
        ),
      );
    }

    if (images.length == 1) {
      return GestureDetector(
        onTap: () => _showImagePreview(images, 0),
        child: Container(
          height: 400,
          child: Image.asset(
            images[0],
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 60,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _showImagePreview(images, index),
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 60,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // 轮播指示器
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentImageIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Row(
        children: [
          isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isActive ? Colors.red : Colors.grey[600]!,
                    ),
                  ),
                )
              : Icon(
                  icon,
                  color: isActive ? Colors.red : Colors.grey[600],
                  size: 24,
                ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.red : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Row(
            children: [
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_comments.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 评论列表
          if (_isLoadingComments)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_comments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No comments yet',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                for (int i = 0; i < _comments.length; i++) ...[
                  _buildCommentItem(
                    userName: _comments[i].userName,
                    time: _comments[i].time,
                    comment: _comments[i].comment,
                    avatar: _comments[i].userAvatar,
                    index: i,
                  ),
                  if (i < _comments.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required String userName,
    required String time,
    required String comment,
    required String avatar,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: Image.asset(
                avatar,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 16,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Stylish report button
          GestureDetector(
            onTap: () => _showReportCommentDialog(userName, comment),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.report_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImagePreviewDialog(
          imagePath: images[initialIndex],
          initialIndex: initialIndex,
          allImages: images,
        );
      },
    );
  }
}

// 视频播放页面
class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  final PostItem post;

  const VideoPlayerPage({
    super.key,
    required this.videoPath,
    required this.post,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    
    if (_showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
          _controller.addListener(() {
            if (mounted) {
              setState(() {});
            }
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 视频播放器
            Center(
              child: _hasError
                  ? const Text(
                      'Video not available',
                      style: TextStyle(color: Colors.white),
                    )
                  : _isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const CircularProgressIndicator(color: Colors.white),
            ),
            // 点击区域控制显示/隐藏控件
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleControls,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 返回按钮
            if (_showControls)
              Positioned(
                top: 16,
                left: 16,
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
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            // 播放/暂停按钮
            if (_showControls && _isInitialized)
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                          _hideControlsAfterDelay();
                        }
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // 底部控制栏（进度条和时间）
            if (_showControls && _isInitialized)
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 进度条
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: _controller.value.position.inMilliseconds.toDouble(),
                          min: 0.0,
                          max: _controller.value.duration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            _controller.seekTo(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 时间显示
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_controller.value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatDuration(_controller.value.duration),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 大尺寸视频缩略图组件
class VideoThumbnailLarge extends StatefulWidget {
  final String videoPath;

  const VideoThumbnailLarge({super.key, required this.videoPath});

  @override
  State<VideoThumbnailLarge> createState() => _VideoThumbnailLargeState();
}

class _VideoThumbnailLargeState extends State<VideoThumbnailLarge> {
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
            _controller!.pause();
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
    } catch (e) {
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                color: Colors.grey,
                size: 60,
              ),
              SizedBox(height: 8),
              Text(
                'Video unavailable',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      children: [
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
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 图片预览对话框
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