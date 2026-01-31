import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';

class IAPProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _isLoading = true;

  // Getters for UI
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;

  IAPProvider() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // Handle error here
        print('error in IAP Provider');
      },
    );

    initialize();
  }

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      await fetchProducts();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    const Set<String> _kIds = {
      'premium_subscription_monthly',
      'yearly_pro',
      kMonthlySubscription,
    };
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _kIds,
    );

    if (response.notFoundIDs.isNotEmpty) {
      // Handle missing IDs
    }
    _products = response.productDetails;
    print('product empty is ${_products.isEmpty}');
    notifyListeners();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        // Show loading indicator in UI
      } else if (purchase.status == PurchaseStatus.error) {
        // Show error message
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // 1. Verify purchase with your backend here
        // 2. Deliver the content

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
    _purchases = purchaseDetailsList;
    notifyListeners();
  }

  // Future<void> buySubscription(ProductDetails product) async {
  //   // 1. Create the purchase parameter
  //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

  //   try {
  //     // 2. For subscriptions and permanent upgrades, use buyNonConsumable
  //     // Note: On iOS, this will automatically handle the App Store purchase flow.
  //     await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  //   } catch (e) {
  //     print('Failed to initiate purchase: $e');
  //   }
  // }

  Future<void> buySubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    // Check if the store is actually reachable first
    if (!await _iap.isAvailable()) {
      print(
        "The store is not available. Check network or device restrictions.",
      );
      return;
    }

    try {
      // This triggers the native Apple overlay
      bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      print("Purchase initiated successfully: $success");
    } catch (e) {
      // This will catch specific StoreKit errors
      print('Detailed Error: $e');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
