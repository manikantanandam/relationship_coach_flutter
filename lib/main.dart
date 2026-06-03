import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/screens/home_screen.dart';
import 'package:relationship_coach_flutter/screens/settings_screen.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';
import 'package:relationship_coach_flutter/services/push_notifications.dart';
import 'package:relationship_coach_flutter/theme/dark_theme.dart';
import 'package:relationship_coach_flutter/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:insert_affiliate_flutter_sdk/insert_affiliate_flutter_sdk.dart';
import 'package:app_links/app_links.dart';

late final InsertAffiliateFlutterSDK insertAffiliateSdk;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase but DON'T request permissions here yet
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Background messaging must be a top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await LocalFeatureFlagManager().init();

  // Initialize Insert Affiliate SDK
  insertAffiliateSdk = InsertAffiliateFlutterSDK(
    companyCode: "swUuyveMlUcwPgRIgJajA7uCdRy2",
    insertLinksEnabled: true,
  );

  // Set up callback for affiliate identifier changes
  insertAffiliateSdk.setInsertAffiliateIdentifierChangeCallback((
    identifier,
    offerCode,
  ) async {
    if (identifier != null) {
      // 1. SharedPreferences లో సేవ్ చేయండి
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_affiliate_id', identifier);

      print('✅ Affiliate ID saved to storage: $identifier');
      // For RevenueCat:
      // var attrs = {"insert_affiliate": identifier, "insert_timedout": ""};
      // if (offerCode != null) attrs["affiliateOfferCode"] = offerCode;
      // await Purchases.setAttributes(attrs);
      // await Purchases.syncAttributesAndOfferingsIfNeeded();

      // For Adapty:
      // final builder = AdaptyProfileParametersBuilder()
      //   ..setCustomStringAttribute(identifier, 'insert_affiliate');
      // await Adapty().updateProfile(builder.build());

      // For Apphud:
      // await Apphud.setUserProperty(key: "insert_affiliate", value: identifier, setOnce: false);
    }
  });

  _setupDeepLinkListener();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IAPProvider()),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

void _setupDeepLinkListener() async {
  final appLinks = AppLinks();

  // Check for initial link
  final initialLink = await appLinks.getInitialLink();
  if (initialLink != null) {
    await insertAffiliateSdk.handleDeepLink(initialLink.toString());
  }

  // Listen for incoming links
  appLinks.uriLinkStream.listen((Uri uri) async {
    await insertAffiliateSdk.handleDeepLink(uri.toString());
  });
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // This executes AFTER the first frame is drawn, preventing the iOS crash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initServices();
    });
  }

  Future<void> _initServices() async {
    print('🎬 _initServices triggered'); // Add this!

    await PushNotificationService().setupNotifications();

    if (mounted) {
      final iap = Provider.of<IAPProvider>(context, listen: false);
      print('🛠 Calling iap.initialize()...');
      await iap.initialize();
    } else {
      print('⚠️ MainApp not mounted, skipping IAP init');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(children: [const HomeScreen(), SettingsScreen()]),
        ),
      ),
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
