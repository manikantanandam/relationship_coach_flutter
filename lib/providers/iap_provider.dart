import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';
import 'package:relationship_coach_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> initialize() async {
    print('🚀 IAP: initialize() started');
    _isLoading = true;
    notifyListeners();

    // 1. Listen to stream IMMEDIATELY
    _subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
      print('📥 IAP: Stream received ${purchaseDetailsList.length} items');
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onError: (error) => print('❌ IAP: Stream Error: $error'));

    try {
      print('📡 IAP: Checking availability...');
      _isAvailable = await _iap.isAvailable().timeout(
        const Duration(seconds: 5),
      );
      print('📡 IAP: isAvailable = $_isAvailable');

      if (_isAvailable) {
        // Don't 'await' these so they don't block each other
        await fetchProducts().catchError(
          (e) => print('❌ IAP: fetchProducts error: $e'),
        );

        if (Platform.isIOS) {
          print('🍏 IAP: Requesting iOS Restore...');
          await _iap.restorePurchases();
        } else if (Platform.isAndroid) {
          print('🤖 IAP: Querying Android Past Purchases...');
          await _queryAndroidPastPurchases();
        }
      }
    } catch (e) {
      print('⚠️ IAP: Initialization timed out or failed: $e');
    }

    _isLoading = false;
    print('🏁 IAP: initialize() completed');
    notifyListeners();
  }

  Future<void> _queryAndroidPastPurchases() async {
    final InAppPurchaseAndroidPlatformAddition androidAddition = _iap
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    final QueryPurchaseDetailsResponse response = await androidAddition
        .queryPastPurchases();

    print(
      '🤖 IAP: Found ${response.pastPurchases.length} past purchases on Android',
    );

    for (var purchase in response.pastPurchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _isSubscribed = true;
        print('✅ IAP: Valid subscription found for ${purchase.productID}');
      }
    }
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

    // if (response.notFoundIDs.isNotEmpty) {
    //   print('Products not found: ${response.notFoundIDs}');
    // }
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    print('📥 IAP: Stream received ${purchaseDetailsList.length} items');

    if (purchaseDetailsList.isEmpty) {
      print('ℹ️ IAP: Stream received but list is empty.');
    }

    for (var purchase in purchaseDetailsList) {
      print(
        '🔍 IAP: Processing ${purchase.productID} | Status: ${purchase.status}',
      );

      if (purchase.status == PurchaseStatus.purchased) {
        // ✅ CORRECT ANDROID INSERT AFFILIATE LOGIC
        if (Platform.isAndroid && purchase is GooglePlayPurchaseDetails) {
          final purchaseToken = purchase.billingClientPurchase.purchaseToken;
          if (purchaseToken.isNotEmpty) {
            await insertAffiliateSdk.storeExpectedStoreTransaction(
              purchaseToken,
            );
          }
        }

        _isSubscribed = true;
        print('✅ IAP: Purchase successful for ${purchase.productID}');

        // (Optional: Save _isSubscribed to SharedPreferences here)
      }

      if (purchase.status == PurchaseStatus.restored) {
        _isSubscribed = true;
        print('✅ IAP: User is SUBSCRIBED to ${purchase.productID}');

        // (Optional: Save _isSubscribed to SharedPreferences here)
      }

      // ✅ THIS SAFELY COMPLETES THE PURCHASE FOR BOTH IOS AND ANDROID
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
        print('📦 IAP: Transaction completed');
      }
    }
    _isPurchasing = false;
    notifyListeners();
  }

  Future<void> buySubscription(ProductDetails product) async {
    String? appAccountToken;
    if (Platform.isIOS) {
      appAccountToken = await insertAffiliateSdk
          .returnUserAccountTokenAndStoreExpectedTransaction();
    }

    _isPurchasing = true;
    notifyListeners();

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
      applicationUserName: appAccountToken,
    );
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
