// lib/services/notification_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  static bool _isInitialized = false;
  static bool _isInitializing = false;

  static FlutterLocalNotificationsPlugin get _instance {
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    return _flutterLocalNotificationsPlugin!;
  }

  static Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _instance.initialize(initializationSettings);
      _isInitialized = true;
      debugPrint("✅ NotificationService initialized successfully");
    } catch (e) {
      debugPrint("❌ Error initializing NotificationService: $e");
      _isInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<bool> _ensureInitialized() async {
    if (_isInitialized) return true;
    
    if (_isInitializing) {
      // Attendre que l'initialisation en cours se termine
      int attempts = 0;
      while (_isInitializing && attempts < 50) { // 5 secondes max
        await Future.delayed(Duration(milliseconds: 100));
        attempts++;
      }
      return _isInitialized;
    }
    
    await initialize();
    return _isInitialized;
  }

  static Future<void> showValidationNotification(bool isAccepted,
      {String? customMessage}) async {
    try {
      final initialized = await _ensureInitialized();
      
      if (!initialized) {
        debugPrint("⚠️ Notification service failed to initialize, skipping notification");
        return;
      }

      await _instance.show(
        1,
        isAccepted ? '🎉 Video acceptee !' : '❌ Video refusee',
        customMessage ??
            (isAccepted
                ? 'Votre video a ete validee par l\'equipe admin.'
                : 'Votre video a ete refusee. Veuillez verifier les criteres.'),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'video_decision_channel',
            'Decision Video',
            channelDescription: 'Notification pour video acceptee ou refusee',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error showing validation notification: $e");
    }
  }

  static Future<void> showFriendRequestNotification(String targetUsername) async {
    try {
      final initialized = await _ensureInitialized();
      
      if (!initialized) {
        debugPrint("⚠️ Notification service failed to initialize, skipping notification");
        return;
      }

      await _instance.show(
        2,
        'Demande d\'ajout envoyee',
        'Une demande d\'ajout a ete envoyee a $targetUsername.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'friend_request_channel',
            'Demande d\'ajout',
            channelDescription: 'Notification pour demande d\'ajout entre utilisateurs',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error showing friend request notification: $e");
    }
  }

  static Future<void> showFollowNotification(String targetUsername) async {
    try {
      final initialized = await _ensureInitialized();
      
      if (!initialized) {
        debugPrint("⚠️ Notification service failed to initialize, skipping notification");
        return;
      }

      await _instance.show(
        3,
        'Nouvel abonne',
        '$targetUsername vous a suivi.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'follow_channel',
            'Nouveau follower',
            channelDescription: 'Notification lorsqu\'un utilisateur vous suit',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error showing follow notification: $e");
    }
  }

  /// Notification pour soumission de vidéo
  static Future<void> showSubmissionNotification() async {
    try {
      final initialized = await _ensureInitialized();
      
      if (!initialized) {
        debugPrint("⚠️ Notification service failed to initialize, skipping notification");
        return;
      }

      await _instance.show(
        4,
        '📤 Video soumise',
        'Votre video a ete soumise avec succes ! Elle sera examinee par notre equipe.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'video_submission_channel',
            'Soumission Vidéo',
            channelDescription: 'Notification lors de la soumission d\'une video',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error showing submission notification: $e");
    }
  }
}