import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:puebly/firebase_options.dart';

class AnalyticsService {
  static final _instance = FirebaseAnalytics.instance;

  static Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await _instance.setAnalyticsCollectionEnabled(true);
  }

  static void selectedSection(String name) async {
    return _instance.logEvent(
      name: 'selected_section',
      parameters: {
        'page_name': name
      }
    );
  }
}