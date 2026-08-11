import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/components/rc_card.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';
import 'package:relationship_coach_flutter/enum/subscription_type.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';
import 'package:relationship_coach_flutter/screens/terms_and_conditions..dart';
import 'dart:io';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:relationship_coach_flutter/services/app_logger.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class RelationshipCoachPremium extends StatelessWidget {
  const RelationshipCoachPremium({super.key});

  void purchaseSubscription(BuildContext context) async {
    final iapProvider = Provider.of<IAPProvider>(context, listen: false);

    // FIX: Use .where().firstOrNull
    final product = iapProvider.products
        .where(
          (prod) =>
              prod.id == IAPConstants.iosSubscriptionId ||
              prod.id == IAPConstants.androidSubscriptionId,
        )
        .firstOrNull;

    if (product != null) {
      AppLogger.logInfo('buying subscription with product id: ${product.id}');
      await iapProvider.buySubscription(product);
      AppLogger.logInfo('buy subscription is completed');
      Navigator.of(context).pop(); // Close the modal after purchase
    } else {
      AppLogger.logError(
        "Product not found for id: ${IAPConstants.iosSubscriptionId} or ${IAPConstants.androidSubscriptionId}",
      );
    }
  }

  void purchaseYearlySubscription(BuildContext context) async {
    final iapProvider = Provider.of<IAPProvider>(context, listen: false);

    // FIX: Use .where().firstOrNull
    final product = iapProvider.products
        .where((prod) => prod.id == IAPConstants.yearlySubscriptionId)
        .firstOrNull;

    if (product != null) {
      AppLogger.logInfo(
        'IAP Productid is ${IAPConstants.yearlySubscriptionId}',
      );
      AppLogger.logInfo('buying subscription with product id: ${product.id}');
      await iapProvider.buySubscription(product);
      Navigator.of(context).pop(); // Close the modal after purchase
      AppLogger.logInfo('buy subscription is completed');
    } else {
      AppLogger.logError(
        "Product not found for id: ${IAPConstants.yearlySubscriptionId}",
      );
    }
  }

  void restorePurchases(BuildContext context) async {
    final iapProvider = Provider.of<IAPProvider>(context, listen: false);

    await iapProvider.restorePurchases();
    Navigator.of(context).pop(); // Close the modal after restoring
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFF4061,
      ), // The vibrant pink from the screenshot
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 15),
                      _buildLogoSection(),
                      const SizedBox(height: 20),
                      _buildImageComparison(),
                      const SizedBox(height: 15),
                      _buildChecklist(),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Fixed syntax
                crossAxisAlignment: CrossAxisAlignment.center, // Fixed syntax
                children: [
                  // Text('TRY FOR FREE', style: TextStyle(fontSize: 25)),
                  Row(
                    // Removed the Expanded wrapper from here
                    children: [
                      // Wrap the cards in Expanded so they take up 50% of the row width each
                      Expanded(
                        child: GestureDetector(
                          onTap: () => purchaseSubscription(context),
                          child: _buildSubscriptionButtonCardType(
                            context,
                            SubscriptionType.monthly,
                          ),
                        ), // Fixed syntax
                      ),

                      const SizedBox(
                        width: 10,
                      ), // Changed height to width for a Row

                      Expanded(
                        child: GestureDetector(
                          onTap: () => purchaseYearlySubscription(context),
                          child: _buildSubscriptionButtonCardType(
                            context,
                            SubscriptionType.yearly,
                          ),
                        ), // Fixed syntax
                      ),
                    ],
                  ),
                  if (Platform.isIOS)
                    const SizedBox(height: 15), // Spacing below cards
                  // NEW PROMO CODE BUTTON HERE
                  _buildFooterLinks(context),

                  const SizedBox(height: 10), // Spacing above footer links
                  // const SizedBox(height: 10),
                  _buildPromoCodeButton(context),
                  const SizedBox(
                    height: 20,
                  ), // Added a little extra padding for the bottom of the screen
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top navigation bar (X and Restore)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: () {
            restorePurchases(context);
          },
          child: const Text(
            'Restore',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  // App Logo and Title
  Widget _buildLogoSection() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('lib/assets/rc_logo.png'),
          ),
          // Placeholder for your heart/infinity logo
        ),
        const SizedBox(height: 15),
        Wrap(
          alignment: .center,
          children: [
            const Text(
              "Relationship Coach",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Pro",
                style: TextStyle(
                  color: Color(0xFFFF4061),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // The two-image comparison row
  Widget _buildImageComparison() {
    return Row(
      children: [
        _buildImageItem(
          "End Arguments",
          "lib/assets/promotionalImages/before_rc.png",
        ),
        const SizedBox(width: 10),
        _buildImageItem(
          "Bring back love",
          "lib/assets/promotionalImages/after_rc.png",
        ),
      ],
    );
  }

  Widget _buildImageItem(String label, String imagePath) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // The feature checklist
  Widget _buildChecklist() {
    final features = [
      "His Fault/ Her Fault Love Chat",
      "My Fault Love Chat",
      "Toxic Chat",
      "Receiving Talk/ Giving Talk",
      "Sweet Talk",
      "Coaching Tips",
      "Guided DIY",
    ];

    return Column(
      children: features
          .map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubscriptionButtonCardType(
    BuildContext context,
    SubscriptionType type,
  ) {
    final iapProvider = Provider.of<IAPProvider>(context, listen: false);
    String productId;

    if (type == .monthly) {
      productId = Platform.isIOS
          ? IAPConstants.iosSubscriptionId
          : IAPConstants.androidSubscriptionId;
    } else {
      productId = IAPConstants.yearlySubscriptionId;
    }
    ProductDetails? currentProduct = iapProvider.products
        .where((prod) => prod.id == productId)
        .firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Container background color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              type.displayName,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            SizedBox(height: 4),
            Text(
              getDisplayPrice(currentProduct),
              style: TextStyle(
                color: Color(0xFFFF4061), // Use the pink color for the price
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              getPerMonthDisplayPrice(currentProduct, type),
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String getDisplayPrice(ProductDetails? product) {
    if (product == null)
      return "ID Error"; // Shows this instead of an empty box

    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final offerDetails = product.productDetails.subscriptionOfferDetails;
      if (offerDetails != null && offerDetails.isNotEmpty) {
        final pricingPhases = offerDetails.first.pricingPhases;
        if (pricingPhases.isNotEmpty) {
          // Grab the LAST phase (the paid recurring price, after any free trials)
          return pricingPhases.last.formattedPrice;
        }
      }
    }

    // Fallback for iOS
    return product.price;
  }

  String getPerMonthDisplayPrice(
    ProductDetails? product,
    SubscriptionType type,
  ) {
    if (product == null) {
      AppLogger.logError(
        "Product is null in getPerMonthDisplayPrice for type: $type",
      );
      return "";
    }

    // 3. Yearly Breakdown Calculation
    double monthlyAmount = 0;

    if (Platform.isAndroid && product is GooglePlayProductDetails) {
      final offerDetails = product.productDetails.subscriptionOfferDetails;
      if (offerDetails != null && offerDetails.isNotEmpty) {
        final pricingPhases = offerDetails.first.pricingPhases;
        if (pricingPhases.isNotEmpty) {
          final lastPhase = pricingPhases.last;
          // Calculate the monthly breakdown from the annual micros
          monthlyAmount =
              lastPhase.priceAmountMicros /
              ((type == SubscriptionType.monthly ? 1 : 12) * 1000000);
          // Notice we are NO LONGER setting the symbol here!
        }
      }
    } else {
      // iOS / Generic fallback
      monthlyAmount =
          product.rawPrice / (type == SubscriptionType.monthly ? 1 : 12);
    }

    if (monthlyAmount == 0) return "";

    return "${product.currencyCode} ${monthlyAmount.toStringAsFixed(2)} / month";
  }

  // Main CTA Button
  Widget _buildSubscriptionButton(BuildContext context, SubscriptionType type) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFF4061),
            minimumSize: const Size(double.infinity, 65),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            switch (type) {
              case SubscriptionType.monthly:
                purchaseSubscription(context);
                break;
              case SubscriptionType.yearly:
                purchaseYearlySubscription(context);
                break;
            }
          },
          child: Column(
            children: [
              Text(
                type == SubscriptionType.monthly
                    ? "3 days trial, then \$9.99 per month"
                    : "3 days trial, then \$59.99 per year",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Legal footers
  Widget _buildFooterLinks(BuildContext context) {
    return Column(
      children: [
        const Text(
          "You can cancel at anytime",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            // Handle Terms & Conditions tap
            print('tap recognizer is working');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TermsAndConditionsScreen(),
              ),
            );
          },
          child: const Text(
            "Terms & Conditions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCodeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _presentPromoCodeSheet(context),
      child: const Text(
        "Have an Offer Code?",
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          decorationColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _presentPromoCodeSheet(BuildContext context) async {
    if (Platform.isIOS) {
      final InAppPurchase iap = InAppPurchase.instance;
      if (await iap.isAvailable()) {
        final iosPlatformAddition = iap
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.presentCodeRedemptionSheet();
      } else {
        AppLogger.logError("Store is not available to redeem code.");
      }
    } else if (Platform.isAndroid) {
      // Android users enter promo codes directly inside the Google Play
      // purchase dialog when they try to buy a normal subscription.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tap a subscription above to enter your promo code at checkout.",
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}
