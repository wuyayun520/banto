import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../../constants/app_constants.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../widgets/user_card_stack.dart';
import '../../widgets/top_options_bar.dart';
import '../../widgets/user_list_view.dart';
import '../../widgets/search_bar_widget.dart';
import '../in_app_purchases_page.dart';
import '../user_detail_page.dart';

class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

  @override
  State<Tab1Page> createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  List<UserModel> _randomUsers = [];
  List<UserModel> _allUsers = [];
  List<UserModel> _displayUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  int _selectedOptionIndex = 0;
  String _searchQuery = '';
  int _goldCoins = 0;
  Set<String> _viewedUsers = {};
  static const int _viewCost = 6; // 查看一个用户消耗6个金币

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGoldCoins();
    _loadViewedUsers();
  }

  Future<void> _loadGoldCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goldCoins = prefs.getInt('petCoins') ?? 0;
    });
  }

  Future<void> _saveGoldCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goldCoins = amount;
    });
    await prefs.setInt('petCoins', _goldCoins);
  }

  Future<void> _loadViewedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedList = prefs.getStringList('viewedUsers') ?? [];
    setState(() {
      _viewedUsers = viewedList.toSet();
    });
  }

  Future<void> _saveViewedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('viewedUsers', _viewedUsers.toList());
  }

  Future<bool> _checkAndConsumeCoins(UserModel user) async {
    // 如果已经查看过这个用户，不需要消耗金币
    if (_viewedUsers.contains(user.userId)) {
      return true;
    }

    // 检查金币是否足够
    if (_goldCoins < _viewCost) {
      _showInsufficientCoinsDialog();
      return false;
    }

    // 消耗金币并记录已查看用户
    await _saveGoldCoins(_goldCoins - _viewCost);
    _viewedUsers.add(user.userId);
    await _saveViewedUsers();
    
    // 显示消耗金币提示
    _showCoinsConsumedSnackBar();
    
    return true;
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_bar,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 标题
                const Text(
                  'Insufficient Fragrance Coins',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // 当前余额
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_bar,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Current: $_goldCoins coins',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // 描述
                Text(
                  'You need $_viewCost fragrance coins to view this profile. Get more coins to unlock premium fragrance experiences!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // 按钮
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InAppPurchasesPage(),
                                ),
                              ).then((_) {
                                // 从内购页面返回后重新加载金币
                                _loadGoldCoins();
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Get Coins',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCoinsConsumedSnackBar() {
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
                Icons.local_bar,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Consumed $_viewCost fragrance coins',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _onUserCardTap(UserModel user) async {
    final canView = await _checkAndConsumeCoins(user);
    if (canView) {
      // 跳转到用户详情页面
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailPage(user: user),
        ),
      );
      
      // 触发震动反馈
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('Loading user data from: ${AppConstants.userDataFile}');
      final String jsonString = await rootBundle.loadString(AppConstants.userDataFile);
      print('JSON loaded successfully, length: ${jsonString.length}');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final UserDataModel userDataModel = UserDataModel.fromJson(jsonData);
      
      print('Total users loaded: ${userDataModel.allData.length}');
      
      // 保存所有用户数据
      _allUsers = userDataModel.allData;
      
      // 随机选择3个用户用于卡片堆叠
      final Random random = Random();
      final List<UserModel> selectedUsers = [];
      
      if (_allUsers.length >= 3) {
        final List<int> selectedIndices = [];
        while (selectedIndices.length < 3) {
          final int randomIndex = random.nextInt(_allUsers.length);
          if (!selectedIndices.contains(randomIndex)) {
            selectedIndices.add(randomIndex);
            selectedUsers.add(_allUsers[randomIndex]);
            print('Selected user ${selectedIndices.length}: ${_allUsers[randomIndex].name}');
          }
        }
      } else {
        selectedUsers.addAll(_allUsers);
        print('Using all available users: ${selectedUsers.length}');
      }
      
      setState(() {
        _randomUsers = selectedUsers;
        _displayUsers = _allUsers; // 默认显示所有用户
        _filteredUsers = _allUsers; // 初始化过滤列表
        _isLoading = false;
      });
      
      print('User data loaded successfully, selected ${selectedUsers.length} users');
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOptionChanged(int index) {
    setState(() {
      _selectedOptionIndex = index;
      switch (index) {
        case 0:
          // 显示全部用户（1-15）
          _displayUsers = _allUsers;
          break;
        case 1:
          // 显示用户1-5
          _displayUsers = _allUsers.take(5).toList();
          break;
        case 2:
          // 显示用户6-10
          _displayUsers = _allUsers.skip(5).take(5).toList();
          break;
        case 3:
          // 显示用户11-15
          _displayUsers = _allUsers.skip(10).take(5).toList();
          break;
      }
      // 应用搜索过滤
      _applySearchFilter();
    });
    print('Option changed to $index, displaying ${_filteredUsers.length} users');
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _applySearchFilter();
    });
    print('Search query: $query, filtered users: ${_filteredUsers.length}');
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _displayUsers;
    } else {
      _filteredUsers = _displayUsers.where((user) {
        return user.name.toLowerCase().contains(_searchQuery) ||
               user.signa.toLowerCase().contains(_searchQuery);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = screenWidth - 48; // 左右各24的边距
    final double cardHeight = screenWidth * 328 / 330-40;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50), // 状态栏间距
              // 搜索栏
              SearchBarWidget(
                hintText: 'Search',
                onSearchChanged: _onSearchChanged,
              ),
              const SizedBox(height: 10), // 搜索栏和下面内容的间距
              // 固定顶部区域
              Container(
                height: 58 + cardHeight + 60 + 10, // 顶部文字 + 卡片 + 选项栏 + 减少间距
                child: Stack(
                  children: [
                    // 顶部文字图片
                    Positioned(
                      top: 10, // 减少顶部间距
                      left: 24,
                      child: Image.asset(
                        AppConstants.homeTopTipsImage,
                        height: 28,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    // 用户卡片背景图片
                    Positioned(
                      top: 48, // 相应调整卡片位置 (20 + 28 + 10)
                      left: 24,
                      right: 24,
                      child: Image.asset(
                        AppConstants.homeCardImage,
                        height: cardHeight,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    // 用户卡片堆叠
                    if (!_isLoading && _randomUsers.isNotEmpty)
                      Positioned(
                        top: 68, // 相应调整堆叠卡片位置 (58 + 20)
                        left: 44,
                        child: UserCardStack(
                          users: _randomUsers,
                          width: cardWidth-40,
                          height: cardHeight-30,
                          onCardTap: _onUserCardTap,
                        ),
                      ),
                    // 4个图片选项栏目
                    Positioned(
                      top: 48 + cardHeight + 10, // 减少选项栏与卡片的间距
                      left: 24,
                      right: 24,
                      child: TopOptionsBar(
                        onSelectionChanged: _onOptionChanged,
                      ),
                    ),
                    // 加载指示器
                    if (_isLoading)
                      Positioned(
                        top: 48 + cardHeight / 2 - 20, // 相应调整加载指示器位置
                        left: screenWidth / 2 - 20,
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7DE8FD)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // 用户列表展示区域
              if (!_isLoading)
                UserListView(
                  users: _filteredUsers,
                  onUserTap: _onUserCardTap, // 传入金币检查回调
                ),
              // 底部间距
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
} 