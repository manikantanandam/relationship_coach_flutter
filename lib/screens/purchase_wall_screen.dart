import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';

class PurchaseWallScreen extends StatelessWidget {
  const PurchaseWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iapProvider = Provider.of<IAPProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Required')),
      body: Center(
        child: Column(
          children: [
            Text('Relationship Coach'),
            ElevatedButton(
              onPressed: () {
                print('Button Pressed!');
                final product = iapProvider.products.firstWhere(
                  (p) => p.id == kMonthlySubscription,
                );
                print('producr is $product');
                iapProvider.buySubscription(product);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
