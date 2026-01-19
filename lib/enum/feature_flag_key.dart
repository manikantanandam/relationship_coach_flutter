enum FeatureKey {
  // theme('app_theme', AppThemeMode.system, AppThemeMode.values),
  chatProvider('chat_provider', ChatServiceType.local, ChatServiceType.values);
  // enableBeta('enable_beta', false, null); // Null for non-enum types

  final String key;
  final Object defaultValue;
  final List<Enum>? options; // Store the .values list here

  const FeatureKey(this.key, this.defaultValue, this.options);
}

enum AppThemeMode { light, dark, system, highContrast }

enum ChatServiceType { firebase, local }
