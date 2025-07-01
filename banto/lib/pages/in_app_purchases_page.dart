import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class GoldProduct {
  final String amountStr;
  final String productId;
  final double price;
  int get amount => int.tryParse(amountStr) ?? 0;
  const GoldProduct(this.amountStr, this.productId, this.price);
}

class GoldProducts {
  static const List<GoldProduct> all = [
    GoldProduct('32', 'Banto', 0.99),
    GoldProduct('96', 'Banto2', 2.99),
    GoldProduct('189', 'Banto5', 5.99),
    GoldProduct('299', 'Banto9', 9.99),
    GoldProduct('599', 'Banto19', 19.99),
    GoldProduct('1599', 'Banto49', 49.99),
    GoldProduct('3199', 'Banto99', 99.99),
    GoldProduct('5099', 'Banto159', 159.99),
    GoldProduct('7959', 'Banto239', 239.99),
  ];
}

class InAppPurchasesPage extends StatefulWidget {
  const InAppPurchasesPage({super.key});

  @override
  State<InAppPurchasesPage> createState() => _InAppPurchasesPageState();
}

class _InAppPurchasesPageState extends State<InAppPurchasesPage> with TickerProviderStateMixin {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  bool _purchasePending = false;
  String? _purchaseError;
  int _goldCoins = 0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  List<GoldProduct> get _goldProducts => GoldProducts.all;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("Error in IAP Stream: $error");
    });
    _loadGoldCoins();
    _initInAppPurchase();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _loadGoldCoins() async {
    final prefs = await SharedPreferences.getInstance();
    int coins = prefs.getInt('petCoins') ?? 0;
    if (!prefs.containsKey('petCoins')) {
      await prefs.setInt('petCoins', 0);
    }
    setState(() {
      _goldCoins = coins;
    });
  }

  Future<void> _saveGoldCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goldCoins += amount;
    });
    await prefs.setInt('petCoins', _goldCoins);
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
    final Set<String> productIds = _goldProducts.map((e) => e.productId).toSet();
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
    final product = _goldProducts.firstWhere((e) => e.productId == purchaseDetails.productID, orElse: () => GoldProduct('', '', 0));
    if (product.amount > 0) {
      await _saveGoldCoins(product.amount);
      _showSnackBar("Purchase successful! +${product.amount} Fragrance Coins");
    }
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _processPurchase(String productId) async {
    final ProductDetails? product = _products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) {
      _showSnackBar("Product not available");
      return;
    }
    setState(() {
      _purchasePending = true;
    });
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      _showSnackBar("Error starting purchase: $e");
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
                  // 自定义AppBar
                  SliverAppBar(
                    expandedHeight: 350,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // 香水主题图标
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors.primaryGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_bar,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // 余额显示
                            Text(
                              '$_goldCoins',
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
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
                            const Text(
                              'Fragrance Coins',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Unlock premium fragrance experiences',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // 商品列表
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _goldProducts[index];
                          final product = _products.firstWhereOrNull((p) => p.id == item.productId);
                          final priceStr = product?.price ?? '\$${item.price.toStringAsFixed(2)}';
                          
                          // 添加特殊标签
                          String? badge;
                          Color? badgeColor;
                          
                          if (index == 2) { // 第3个商品
                            badge = 'Popular';
                            badgeColor = AppColors.primary;
                          } else if (index == 5) { // 第6个商品
                            badge = 'Best Value';
                            badgeColor = const Color(0xFF4CAF50);
                          }
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: _purchasePending ? null : () => _processPurchase(item.productId),
                                child: Stack(
                                  children: [
                                    // 特殊标签
                                    if (badge != null)
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: badgeColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            badge,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          // 香水瓶图标
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              gradient: AppColors.primaryGradient,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.local_bar,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 16),
                                          
                                          // 商品信息
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${item.amount} Fragrance Coins',
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Unlock premium fragrance profiles',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // 价格按钮
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              gradient: AppColors.primaryGradient,
                                              borderRadius: BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              priceStr,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
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
                        },
                        childCount: _goldProducts.length,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF8000),
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
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