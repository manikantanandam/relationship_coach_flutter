import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';

class IAPProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isLoading = true;
  bool _isPurchasing = false;
  bool _isSubscribed = false;

  // Getters
  List<ProductDetails> get products => _products;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  bool get isPurchasing => _isPurchasing;
  bool get isSubscribed => _isSubscribed;

  IAPProvider() {
    print('IAPProvider allocated in memory');
    // DO NOT call initialize() or listen to streams here.
  }

  /// This is called from your UI's PostFrameCallback
  Future<void> initialize() async {
    print('Starting IAP Initialization...');

    // 1. Listen to the stream first (Safe now because the app is running)
    _subscription = _iap.purchaseStream.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () => _subscription?.cancel(),
      onError: (error) => print('IAP Stream Error: $error'),
    );

    // 2. Check availability
    _isAvailable = await _iap.isAvailable();

    if (_isAvailable) {
      await fetchProducts();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> restorePurchases() async {
    print('User initiated restore purchases...');
    await _iap.restorePurchases();
  }

  Future<void> fetchProducts() async {
    final Set<String> _kIds = {
      IAPConstants.iosSubscriptionId,
      IAPConstants.androidSubscriptionId,
      IAPConstants.yearlySubscriptionId,
    };
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _kIds,
    );

    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        _isPurchasing = true;
      } else {
        _isPurchasing = false;

        if (purchase.status == PurchaseStatus.error) {
          _isSubscribed = false;
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _isSubscribed = true;
        }

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
    notifyListeners();
  }

  Future<void> buySubscription(ProductDetails product) async {
    _isPurchasing = true;
    notifyListeners();

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      // Let the stream handle setting _isPurchasing to false
    } catch (e) {
      print('Failed to initiate purchase: $e');
      _isPurchasing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
