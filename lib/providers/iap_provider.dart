import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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
    const Set<String> _kIds = {'premium_subscription_monthly', 'yearly_pro'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _kIds,
    );

    if (response.notFoundIDs.isNotEmpty) {
      // Handle missing IDs
    }
    _products = response.productDetails;
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

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
