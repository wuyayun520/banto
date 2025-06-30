import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class ChatHistoryService {
  static const String _chatHistoryPrefix = 'chat_history_';
  static const String _chatUsersKey = 'chat_users';

  // 获取聊天过的用户列表
  static Future<List<ChatUserInfo>> getChatUsers() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_chatUsersKey.json');
      
      if (!await file.exists()) {
        return [];
      }
      
      final jsonStr = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonStr);
      
      List<ChatUserInfo> chatUsers = jsonList
          .map((e) => ChatUserInfo.fromJson(e))
          .toList();
      
      // 按最后聊天时间排序
      chatUsers.sort((a, b) => b.lastChatTime.compareTo(a.lastChatTime));
      
      return chatUsers;
    } catch (e) {
      print('Error loading chat users: $e');
      return [];
    }
  }

  // 保存聊天用户信息
  static Future<void> saveChatUser(UserModel user, String lastMessage, ChatMessageType messageType) async {
    try {
      List<ChatUserInfo> chatUsers = await getChatUsers();
      
      // 查找是否已存在该用户
      int existingIndex = chatUsers.indexWhere((u) => u.userId == user.userId);
      
      ChatUserInfo chatUserInfo = ChatUserInfo(
        userId: user.userId,
        userName: user.name,
        userIcon: user.userIcon,
        lastMessage: lastMessage,
        lastMessageType: messageType,
        lastChatTime: DateTime.now(),
        unreadCount: 0,
      );
      
      if (existingIndex != -1) {
        // 更新现有用户信息
        chatUsers[existingIndex] = chatUserInfo;
      } else {
        // 添加新用户
        chatUsers.insert(0, chatUserInfo);
      }
      
      // 保存到本地
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_chatUsersKey.json');
      final jsonStr = json.encode(chatUsers.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonStr);
    } catch (e) {
      print('Error saving chat user: $e');
    }
  }

  // 获取特定用户的聊天消息
  static Future<List<ChatMessage>> getChatMessages(String userId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_chatHistoryPrefix$userId.json');
      
      if (!await file.exists()) {
        return [];
      }
      
      final jsonStr = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonStr);
      
      return jsonList.map((e) => ChatMessage.fromJson(e)).toList();
    } catch (e) {
      print('Error loading chat messages: $e');
      return [];
    }
  }
}

// 聊天用户信息模型
class ChatUserInfo {
  final String userId;
  final String userName;
  final String userIcon;
  final String lastMessage;
  final ChatMessageType lastMessageType;
  final DateTime lastChatTime;
  final int unreadCount;

  ChatUserInfo({
    required this.userId,
    required this.userName,
    required this.userIcon,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastChatTime,
    required this.unreadCount,
  });

  factory ChatUserInfo.fromJson(Map<String, dynamic> json) {
    return ChatUserInfo(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userIcon: json['userIcon'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageType: ChatMessageType.values[json['lastMessageType'] ?? 0],
      lastChatTime: DateTime.parse(json['lastChatTime'] ?? DateTime.now().toIso8601String()),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userIcon': userIcon,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType.index,
      'lastChatTime': lastChatTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(lastChatTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastChatTime.month}/${lastChatTime.day}';
    }
  }

  String get displayMessage {
    switch (lastMessageType) {
      case ChatMessageType.text:
        return lastMessage;
      case ChatMessageType.image:
        return '[Image]';
      case ChatMessageType.audio:
        return '[Voice Message]';
      default:
        return lastMessage;
    }
  }
}

// 聊天消息模型
class ChatMessage {
  final String? text;
  final String? imagePath;
  final String? audioPath;
  final Duration? audioDuration;
  final bool isMe;
  final String time;
  final ChatMessageType type;

  ChatMessage({
    this.text,
    this.imagePath,
    this.audioPath,
    this.audioDuration,
    required this.isMe,
    required this.time,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      audioDuration: json['audioDuration'] != null 
          ? Duration(milliseconds: json['audioDuration'])
          : null,
      isMe: json['isMe'] ?? false,
      time: json['time'] ?? '',
      type: ChatMessageType.values[json['type'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'audioDuration': audioDuration?.inMilliseconds,
      'isMe': isMe,
      'time': time,
      'type': type.index,
    };
  }
}

enum ChatMessageType {
  text,
  image,
  audio,
} 