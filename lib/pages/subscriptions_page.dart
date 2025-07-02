import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class SubscriptionsPage extends StatefulWidget {
  final int initialIndex;
  const SubscriptionsPage({super.key, this.initialIndex = 0});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> with TickerProviderStateMixin {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  bool _purchasePending = false;
  String? _purchaseError;
  int _selectedIndex = 0;
  bool _isVip = false;
  DateTime? _vipExpiry;
  DateTime? _lastSnackBarTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // 订阅商品配置
  final List<_VipPlan> _plans = [
    _VipPlan(
      title: '12.99',
      subTitle: 'Per week',
      total: 'Total \$12.99',
      desc: '+7 Days Premium',
      productId: 'BantoWeekVIP',
      popular: false,
    ),
    _VipPlan(
      title: '49.99',
      subTitle: 'Per month',
      total: 'Total \$49.99',
      desc: '+30 Days Premium',
      productId: 'BantoMonthVIP',
      popular: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    
    // 初始化动画控制器
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
    
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("Error in IAP Stream: $error");
    });
    _initInAppPurchase();
    _loadVipStatus();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initInAppPurchase() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isLoading = false;
        _purchaseError = "Store is not available.";
      });
      return;
    }
    final Set<String> productIds = _plans.map((e) => e.productId).toSet();
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);
      setState(() {
        _products = response.productDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _purchaseError = "Failed to load products: $e";
      });
    }
  }

  Future<void> _loadVipStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVip = prefs.getBool('isVip') ?? false;
      final expiryStr = prefs.getString('vipExpiry');
      _vipExpiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            _purchasePending = false;
            _purchaseError = purchaseDetails.error?.message ?? "Unknown error occurred";
          });
          _showSnackBar("Purchase failed: ${purchaseDetails.error?.message ?? 'Unknown error'}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _handleSuccessfulPurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          setState(() {
            _purchasePending = false;
          });
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    setState(() {
      _purchasePending = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVip', true);
    
    // 保存订阅类型
    await prefs.setString('vipSubscriptionType', purchaseDetails.productID);
    
    // 计算有效期
    DateTime now = DateTime.now();
    DateTime expiry;
    if (purchaseDetails.productID == 'BantoWeekVIP') {
      expiry = now.add(const Duration(days: 7));
    } else if (purchaseDetails.productID == 'BantoMonthVIP') {
      expiry = now.add(const Duration(days: 30));
    } else {
      expiry = now;
    }
    await prefs.setString('vipExpiry', expiry.toIso8601String());
    _showSnackBar("Premium activated!");
    await _loadVipStatus();
  }

  void _showSnackBar(String msg) {
    final now = DateTime.now();
    if (_lastSnackBarTime != null && now.difference(_lastSnackBarTime!).inSeconds < 3) {
      return;
    }
    _lastSnackBarTime = now;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Future<void> _processPurchase() async {
    final plan = _plans[_selectedIndex];
    final ProductDetails? product = _products.firstWhereOrNull((p) => p.id == plan.productId);
    if (product == null) {
      _showSnackBar("Product not available");
      return;
    }
    setState(() {
      _purchasePending = true;
    });
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      _showSnackBar("Error starting purchase: $e");
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _purchasePending = true;
    });
    try {
      await _inAppPurchase.restorePurchases();
      _showSnackBar("Restoring purchases...");
    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      _showSnackBar("Error restoring purchases: $e");
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define privileges for each plan
    final List<List<_Privilege>> planPrivileges = [
      // Weekly
      [
        _Privilege(icon: Icons.explore, text: 'Unlimited browsing to discover works'),
        _Privilege(icon: Icons.smart_toy, text: 'Unlimited consultation with AI advisors'),
        _Privilege(icon: Icons.camera_alt, text: 'Unlimited modification of user avatars'),
        _Privilege(icon: Icons.favorite, text: 'Like and collect your favorite users infinitely'),
        _Privilege(icon: Icons.download, text: 'Save others\' work pictures without limit'),
        _Privilege(icon: Icons.mic, text: 'Chatting can send voice messages'),
        _Privilege(icon: Icons.block, text: 'Ad-free experience'),
      ],
      // Monthly
      [
        _Privilege(icon: Icons.explore, text: 'Unlimited browsing to discover works'),
        _Privilege(icon: Icons.smart_toy, text: 'Unlimited consultation with AI advisors'),
        _Privilege(icon: Icons.camera_alt, text: 'Unlimited modification of user avatars'),
        _Privilege(icon: Icons.favorite, text: 'Like and collect your favorite users infinitely'),
        _Privilege(icon: Icons.download, text: 'Save others\' work pictures without limit'),
        _Privilege(icon: Icons.video_library, text: 'Save others\' video works without limit'),
        _Privilege(icon: Icons.mic, text: 'Chatting can send voice messages'),
        _Privilege(icon: Icons.videocam, text: 'Chatting can involve making video calls'),
        _Privilege(icon: Icons.comment, text: 'Post a dynamic comment and share your thoughts'),
        _Privilege(icon: Icons.block, text: 'Ad-free experience'),
      ],
    ];
    final privileges = planPrivileges[_selectedIndex];
    
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    expandedHeight: _isVip && _vipExpiry != null ? 380 : 280,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              
                              // VIP Status Card (if active)
                              if (_isVip && _vipExpiry != null) ...[
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.local_bar, color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Banto Premium Active',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Expires: ${_vipExpiry!.year}-${_vipExpiry!.month.toString().padLeft(2, '0')}-${_vipExpiry!.day.toString().padLeft(2, '0')} (${_vipExpiry!.difference(DateTime.now()).inDays} days)',
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.9),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              
                              // Animated Perfume Theme
                              SizedBox(
                                height: 160,
                                width: 160,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Background glow effect
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          width: 140 * _pulseAnimation.value,
                                          height: 140 * _pulseAnimation.value,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: RadialGradient(
                                              colors: [
                                                AppColors.primary.withValues(alpha: 0.3),
                                                AppColors.primary.withValues(alpha: 0.1),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    
                                    // Main perfume bottle container
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 0.9 + (_pulseAnimation.value - 0.8) * 0.5,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              gradient: AppColors.primaryGradient,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withValues(alpha: 0.4),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Perfume bottle icon
                                                const Icon(
                                                  Icons.local_bar,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                                // Sparkle effect
                                                Positioned(
                                                  top: 15,
                                                  right: 20,
                                                  child: AnimatedBuilder(
                                                    animation: _pulseAnimation,
                                                    builder: (context, child) {
                                                      return Transform.rotate(
                                                        angle: _pulseAnimation.value * 6.28,
                                                        child: Icon(
                                                          Icons.auto_awesome,
                                                          color: Colors.white.withValues(alpha: 0.8),
                                                          size: 12,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    
                                    // Floating scent particles
                                    ...List.generate(6, (index) {
                                      final angle = (index * 60.0) * (3.14159 / 180);
                                      return AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) {
                                          final radius = 60 + (10 * _pulseAnimation.value);
                                          return Positioned(
                                            left: 50 + radius * cos(angle + _pulseAnimation.value * 2),
                                            top: 50 + radius * sin(angle + _pulseAnimation.value * 2),
                                            child: Container(
                                              width: 4 + (2 * _pulseAnimation.value),
                                              height: 4 + (2 * _pulseAnimation.value),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(
                                                  alpha: 0.6 * (1.5 - _pulseAnimation.value),
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Title
                              const Text(
                                'Banto Premium',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  letterSpacing: 1.0,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 6),
                              
                              // Subtitle
                              Text(
                                'Unlock the ultimate fragrance experience',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subscription Plans
                          Row(
                            children: List.generate(_plans.length, (i) {
                              final plan = _plans[i];
                              final selected = i == _selectedIndex;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = i;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: i == 0 ? 12 : 0, left: i == 1 ? 12 : 0),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: selected ? AppColors.primaryGradient : null,
                                      color: selected ? null : Colors.white.withValues(alpha: 0.95),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selected 
                                              ? AppColors.primary.withValues(alpha: 0.4)
                                              : Colors.black.withValues(alpha: 0.1),
                                          blurRadius: selected ? 15 : 10,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        if (plan.popular)
                                          Positioned(
                                            top: -8,
                                            right: -8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                gradient: AppColors.primaryGradient,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              
                                            ),
                                          ),
                                        Column(
                                          children: [
                                            Text(
                                              '\$${plan.title}',
                                              style: TextStyle(
                                                color: selected ? Colors.white : AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              plan.subTitle,
                                              style: TextStyle(
                                                color: selected ? Colors.white.withValues(alpha: 0.9) : AppColors.textSecondary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: selected 
                                                    ? Colors.white.withValues(alpha: 0.2)
                                                    : AppColors.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                plan.desc,
                                                style: TextStyle(
                                                  color: selected ? Colors.white : AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Features Title
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              'Premium Features',
                              style: TextStyle(
                                color:AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                shadows: const [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Features List
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                for (int i = 0; i < privileges.length; i++) ...[
                                  _VipPrivilegeItem(
                                    icon: privileges[i].icon,
                                    text: privileges[i].text,
                                  ),
                                  if (i != privileges.length - 1) 
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Divider(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        height: 1,
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Purchase Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: GestureDetector(
                              onTap: _purchasePending ? null : _processPurchase,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: _purchasePending
                                    ? const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Start Banto Premium',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          
                          if (!_isVip) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: _purchasePending ? null : _restorePurchases,
                                child: Text(
                                  'Restore Purchases',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 30),
                          
                          // Legal Links
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => _launchURL('https://sites.google.com/view/bantoprivacy/view'),
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              TextButton(
                                onPressed: () => _launchURL('https://www.apple.com/legal/internet-services/itunes/dev/stdeula'),
                                child: Text(
                                  'Terms of Use',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 32),
                          
                          // Subscription Terms
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Subscription Terms',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '• Weekly subscription: \$12.99 per week\n'
                                  '• Monthly subscription: \$49.99 per month\n\n'
                                  'Payment will be charged to your Apple ID account at the confirmation of purchase. Your subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. You can manage and cancel your subscriptions by going to your App Store account settings after purchase.\n\n'
                                  'To cancel your subscription:\n'
                                  '1. Open the Settings app\n'
                                  '2. Tap your Apple ID at the top\n'
                                  '3. Tap Subscriptions\n'
                                  '4. Find Banto Premium in the list\n'
                                  '5. Tap Cancel Subscription',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
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

class _VipPlan {
  final String title;
  final String subTitle;
  final String total;
  final String desc;
  final String productId;
  final bool popular;
  const _VipPlan({
    required this.title,
    required this.subTitle,
    required this.total,
    required this.desc,
    required this.productId,
    required this.popular,
  });
}

class _VipPrivilegeItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _VipPrivilegeItem({required this.icon, required this.text});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class _Privilege {
  final IconData icon;
  final String text;
  const _Privilege({required this.icon, required this.text});
}