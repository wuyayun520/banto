import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'main_tab_page.dart';
import 'terms_of_service_page.dart';
import 'privacy_policy_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAgreed = true;

  void _onEnterApp() {
    if (_isAgreed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainTabPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms of Service and Privacy Policy first'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.loginBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // 底部内容区域
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Column(
                  children: [
                    // Enter APP 按钮
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE5FEDC),
                            Color(0xFF7DE8FD),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7DE8FD).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _onEnterApp,
                          borderRadius: BorderRadius.circular(28),
                          child: const Center(
                            child: Text(
                              AppConstants.enterApp,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 服务条款和隐私政策
                    Row(
                      children: [
                        // 自定义复选框
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAgreed = !_isAgreed;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _isAgreed 
                                  ? const Color(0xFF7DE8FD) 
                                  : Colors.transparent,
                              border: Border.all(
                                color: _isAgreed 
                                    ? const Color(0xFF7DE8FD) 
                                    : Colors.white.withOpacity(0.6),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _isAgreed
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // 文本内容
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(text: AppConstants.agreeTerms),
                                const TextSpan(text: ' '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const TermsOfServicePage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppConstants.termsOfService,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' ${AppConstants.and} '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppConstants.privacyPolicy,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 