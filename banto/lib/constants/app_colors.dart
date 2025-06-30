import 'package:flutter/material.dart';

class AppColors {
  // 主要颜色
  static const Color primary = Color(0xFF7DE8FD);
  static const Color secondary = Color(0xFF5BC0DE);
  
  // 文本颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  
  // 状态颜色
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // 渐变
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 