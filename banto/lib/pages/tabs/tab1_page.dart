import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import '../../constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../widgets/user_card_stack.dart';
import '../../widgets/top_options_bar.dart';
import '../../widgets/user_list_view.dart';
import '../../widgets/search_bar_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                UserListView(users: _filteredUsers),
              // 底部间距
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
} 