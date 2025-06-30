import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = 'c560d00edb994d90b0d5452e1e76c978.Syzaqdc0SAoa0be5';
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
  
  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'glm-4-flash',
          'messages': [
            {
              'role': 'system',
              'content': 'You are ScentAI, a professional perfume consultant and fragrance expert. You help users with perfume recommendations, fragrance knowledge, and scent-related questions. Always respond in English and provide helpful, accurate information about perfumes and fragrances. Be friendly and enthusiastic about fragrances.'
            },
            {
              'role': 'user',
              'content': message
            }
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'];
        } else {
          return 'Sorry, I couldn\'t process your request right now. Please try again.';
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return 'I\'m having trouble connecting right now. Please check your internet connection and try again.';
      }
    } catch (e) {
      print('Error sending message: $e');
      return 'Something went wrong. Please try again later.';
    }
  }
} 