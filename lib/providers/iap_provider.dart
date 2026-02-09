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
  bool _isPurchasing = false;
  bool get isPurchasing => _isPurchasing;

  // Getters for UI
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;

  IAPProvider() {
    print('IAPProvider Initialized');
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    testStreamConnection();
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        print('purchase details updated: $purchaseDetailsList');
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

  Future<void> testStreamConnection() async {
    print('Manually poking the stream...');
    // This forces StoreKit to check for past transactions.
    // It SHOULD trigger your "purchase details updated" print.
    await _iap.restorePurchases();
  }

  Future<void> fetchProducts() async {
    final Set<String> _kIds = {
      'premium_subscription_monthly',
      'yearly_pro',
      IAPConstants.monthlySubscriptionId,
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
    print('listen to purchase update called');
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        print('purchase pending...');
        // Still waiting...
      } else {
        // The purchase finished, failed, or was restored.
        _isPurchasing = false;

        if (purchase.status == PurchaseStatus.error) {
          print('Error: ${purchase.error}');
        } else if (purchase.status == PurchaseStatus.purchased) {
          // Unlock content
          print('purchase successful!');
        }

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
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
    _isPurchasing = true;
    notifyListeners(); // Show a spinner in your UI

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      // Do NOT set _isPurchasing = false here.
      // Wait for the stream to return a status (Error or Success).
    } catch (e) {
      _isPurchasing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
