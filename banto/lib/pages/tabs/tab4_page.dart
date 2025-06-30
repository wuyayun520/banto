import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../constants/app_constants.dart';
import '../../services/chat_history_service.dart';
import '../../models/user_model.dart';
import '../chat_page.dart';

class Tab4Page extends StatefulWidget {
  const Tab4Page({super.key});

  @override
  State<Tab4Page> createState() => _Tab4PageState();
}

class _Tab4PageState extends State<Tab4Page> with AutomaticKeepAliveClientMixin {
  List<ChatUserInfo> _chatUsers = [];
  bool _isLoading = true;
  List<UserModel> _allUsers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    try {
      final String jsonString = await rootBundle.loadString(AppConstants.userDataFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final UserDataModel userDataModel = UserDataModel.fromJson(jsonData);
      
      setState(() {
        _allUsers = userDataModel.allData;
      });
    } catch (e) {
      print('Error loading all users: $e');
    }
  }

  Future<void> _loadChatUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final chatUsers = await ChatHistoryService.getChatUsers();
      setState(() {
        _chatUsers = chatUsers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading chat users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  UserModel? _findUserById(String userId) {
    try {
      return _allUsers.firstWhere((user) => user.userId == userId);
    } catch (e) {
      return null;
    }
  }

  void _navigateToChat(ChatUserInfo chatUserInfo) {
    final user = _findUserById(chatUserInfo.userId);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(user: user),
        ),
      ).then((_) {
        // 从聊天页面返回时刷新列表
        _loadChatUsers();
      });
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
          child: Column(
            children: [
              // 标题栏
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _loadChatUsers,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.black87,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              // 聊天列表
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7DE8FD)),
                        ),
                      )
                    : _chatUsers.isEmpty
                        ? _buildEmptyState()
                        : _buildChatList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 60,
              color: Color(0xFF7DE8FD),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start chatting with friends to see\nyour conversations here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _chatUsers.length,
      itemBuilder: (context, index) {
        final chatUser = _chatUsers[index];
        return _buildChatUserItem(chatUser);
      },
    );
  }

  Widget _buildChatUserItem(ChatUserInfo chatUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToChat(chatUser),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 用户头像
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7DE8FD).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[300],
                    child: chatUser.userIcon.isNotEmpty
                        ? ClipOval(
                            child: Image.asset(
                              chatUser.userIcon,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 28,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 28,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // 用户信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatUser.userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            chatUser.formattedTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatUser.displayMessage,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chatUser.unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF7DE8FD), Color(0xFF5BC0DE)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chatUser.unreadCount > 99 
                                    ? '99+' 
                                    : chatUser.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 右箭头
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 