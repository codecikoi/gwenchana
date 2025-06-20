import 'package:flutter_dotenv/flutter_dotenv.dart';

class FireBaseOptionsService {
  final String apiKeyAndroid = dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
  final String appIdAndroid = dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';
  final String messagingSenderId =
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  final String projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  final String storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';

  final String bundleIdIos = dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '';
  final String apiKeyIos = dotenv.env['FIREBASE_API_KEY_IOS'] ?? '';
  final String appIdIos = dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';
}
