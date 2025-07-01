import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../constants/app_constants.dart';
import '../../constants/app_colors.dart';
import '../../services/user_profile_service.dart';
import '../about_us_page.dart';
import '../privacy_policy_page.dart';
import '../terms_of_service_page.dart';
import '../my_collection_page.dart';
import '../subscriptions_page.dart';
import '../in_app_purchases_page.dart';

class Tab5Page extends StatefulWidget {
  const Tab5Page({super.key});

  @override
  State<Tab5Page> createState() => _Tab5PageState();
}

class _Tab5PageState extends State<Tab5Page> with AutomaticKeepAliveClientMixin {
  UserProfile? _userProfile;
  bool _isLoading = true;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _signatureController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final profile = await UserProfileService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _nameController.text = profile.name;
        _signatureController.text = profile.signature;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (_userProfile == null) return;
    
    final updatedProfile = _userProfile!.copyWith(
      name: _nameController.text.trim(),
      signature: _signatureController.text.trim(),
    );
    
    final success = await UserProfileService.saveUserProfile(updatedProfile);
    
    if (success) {
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });
      _showSuccessMessage('Profile saved successfully!');
      // 触发震动反馈
      HapticFeedback.lightImpact();
    } else {
      _showErrorMessage('Failed to save profile. Please try again.');
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _nameController.text = _userProfile?.name ?? '';
        _signatureController.text = _userProfile?.signature ?? '';
      }
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = _userProfile?.name ?? '';
      _signatureController.text = _userProfile?.signature ?? '';
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        // 获取应用文档目录
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String avatarDir = '${appDocDir.path}/avatars';
        
        // 创建头像目录（如果不存在）
        final Directory avatarDirectory = Directory(avatarDir);
        if (!await avatarDirectory.exists()) {
          await avatarDirectory.create(recursive: true);
        }
        
        // 生成唯一的文件名
        final String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String savedPath = '$avatarDir/$fileName';
        
        // 复制文件到应用目录
        final File savedImage = await File(image.path).copy(savedPath);
        
        if (await savedImage.exists()) {
          // 更新用户资料
          setState(() {
            _userProfile = _userProfile!.copyWith(avatar: savedPath);
          });
          
          // 保存到本地存储
          await UserProfileService.saveUserProfile(_userProfile!);
          
          // 震动反馈
          HapticFeedback.selectionClick();
          
          // 显示成功提示
          _showSuccessMessage('Avatar updated successfully!');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      _showErrorMessage('Failed to select image. Please try again.');
    }
  }

  void _showSuccessMessage(String message) {
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
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorMessage(String message) {
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
              child: const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_userProfile?.avatar != null) {
      final avatarPath = _userProfile!.avatar;
      
      // 判断是否为本地文件路径
      if (avatarPath.startsWith('/') || avatarPath.startsWith('file://')) {
        // 本地文件
        return Image.file(
          File(avatarPath),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 40,
              ),
            );
          },
        );
      } else {
        // Assets资源
        return Image.asset(
          avatarPath,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 40,
              ),
            );
          },
        );
      }
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Icon(
          Icons.person,
          color: Colors.grey,
          size: 40,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
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
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7DE8FD)),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // 顶部个人资料卡片
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 头像
                            GestureDetector(
                              onTap: _isEditing ? _pickImageFromGallery : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: _buildAvatarImage(),
                                      ),
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            gradient: AppColors.primaryGradient,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // 名称和签名
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 名称
                                  _isEditing
                                      ? TextField(
                                          controller: _nameController,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                                          ),
                                          maxLength: 30,
                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                        )
                                      : Text(
                                          _userProfile?.name ?? 'Darlene Beats',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                  const SizedBox(height: 8),
                                  // 签名
                                  _isEditing
                                      ? TextField(
                                          controller: _signatureController,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                                          ),
                                          maxLength: 100,
                                          maxLines: 2,
                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                                        )
                                      : Text(
                                          _userProfile?.signature ?? 'An ordinary perfume collector',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            // 编辑按钮
                            IconButton(
                              onPressed: _toggleEdit,
                              icon: Icon(
                                _isEditing ? Icons.close : Icons.edit,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // VIP图片
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SubscriptionsPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              height: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/banto_me_vip.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[500],
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 编辑模式下的保存/取消按钮
                      if (_isEditing)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _cancelEdit,
                                      borderRadius: BorderRadius.circular(24),
                                      child: const Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _saveUserProfile,
                                      borderRadius: BorderRadius.circular(24),
                                      child: const Center(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // 选项列表
                      const SizedBox(height: 32),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildOptionItem(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'Balance',
                              onTap: () {
                                // 导航到金币购买页面
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InAppPurchasesPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildOptionItem(
                              icon: Icons.info_outline,
                              title: 'About Us',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AboutUsPage()),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildOptionItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildOptionItem(
                              icon: Icons.description_outlined,
                              title: 'Terms of Service',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TermsOfServicePage()),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildOptionItem(
                              icon: Icons.favorite_outlined,
                              title: 'My Collection',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MyCollectionPage()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 