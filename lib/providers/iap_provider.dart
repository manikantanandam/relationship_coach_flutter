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

  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  IAPProvider() {
    print('IAPProvider Initialized');

    // 1. Set up the listener FIRST to catch any ghost transactions immediately
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        print('purchase details updated: $purchaseDetailsList');
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        print('error in IAP Provider: $error');
      },
    );

    // 2. REMOVED restorePurchases() from here. Only trigger it via user action.

    // 3. Initialize products
    initialize();
  }

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      await fetchProducts();
    }
    _isLoading = false;
    notifyListeners();
    await restorePurchases(); // Optionally restore purchases on app start to sync state
  }

  Future<void> restorePurchases() async {
    print('User initiated restore purchases...');
    await _iap.restorePurchases();
  }

  Future<void> fetchProducts() async {
    final Set<String> _kIds = {IAPConstants.monthlySubscriptionId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _kIds,
    );

    if (response.notFoundIDs.isNotEmpty) {
      print('Products not found: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
    notifyListeners();
  }

  // Changed to async to await completePurchase
  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    print('listen to purchase update called');
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        print('purchase pending...');
        _isPurchasing = true;
      } else {
        _isPurchasing = false;
        print('purchase is not pending anymore ${purchase.status}');

        if (purchase.status == PurchaseStatus.error) {
          print('Error: ${purchase.error}');
          _isSubscribed = false;
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          print('purchase successful!');
          _isSubscribed = true;
        }

        // CRITICAL: Await the completion so StoreKit clears it from the queue
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
          print('Purchase marked as complete in StoreKit');
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
    _subscription.cancel();
    super.dispose();
  }
}
