import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/constants.dart/iap_constants.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';
import 'package:flutter/material.dart';

class RelationshipCoachPremium extends StatelessWidget {
  const RelationshipCoachPremium({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFF4061,
      ), // The vibrant pink from the screenshot
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildLogoSection(),
                const SizedBox(height: 40),
                _buildImageComparison(),
                const SizedBox(height: 30),
                _buildChecklist(),
                const SizedBox(height: 40),
                _buildSubscriptionButton(),
                const SizedBox(height: 20),
                _buildFooterLinks(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Top navigation bar (X and Restore)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () {},
        ),
        TextButton(
          onPressed: () {},
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
          height: 120,
          width: 120,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
          "End Arguments Now",
          "lib/assets/promotionalImages/after_rc.png",
        ),
        const SizedBox(width: 10),
        _buildImageItem(
          "Bring back the love",
          "lib/assets/promotionalImages/before_rc.png",
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

  // Main CTA Button
  Widget _buildSubscriptionButton() {
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
          onPressed: () {},
          child: Column(
            children: const [
              Text(
                "TRY FOR FREE",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "3 days trial, then \$9.99 per month",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Legal footers
  Widget _buildFooterLinks() {
    return Column(
      children: const [
        Text(
          "You can cancel at anytime",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SizedBox(height: 5),
        Text(
          "Terms & Conditions",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
