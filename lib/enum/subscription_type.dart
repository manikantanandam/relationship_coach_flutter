enum SubscriptionType { monthly, yearly }

extension SubscriptionTypeExtension on SubscriptionType {
  String get displayName {
    switch (this) {
      case SubscriptionType.monthly:
        return "1 Month";
      case SubscriptionType.yearly:
        return "1 Year";
    }
  }

  String get amount {
    switch (this) {
      case SubscriptionType.monthly:
        return "\$9.99";
      case SubscriptionType.yearly:
        return "\$69.99";
    }
  }

  String get perMonth {
    switch (this) {
      case SubscriptionType.monthly:
        return "\$9.99/Month";
      case SubscriptionType.yearly:
        return "\$5.75/Month";
    }
  }
}
