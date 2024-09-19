import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(Recommendation recommendation) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'weather_recommendations',
      'Weather Recommendations',
      'Notifications for weather-based recommendations',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Weather Alert',
      recommendation.message,
      platformChannelSpecifics,
    );

    await _saveAlertToDatabase(recommendation);
  }

  Future<void> _saveAlertToDatabase(Recommendation recommendation) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final farmResponse = await _supabase
          .from('Farms')
          .select()
          .eq('user_id', user.id)
          .single();

      final farmId = farmResponse['id'];

      await _supabase.from('Alerts').insert({
        'farm_id': farmId,
        'alert_type': recommendation.type.toString().split('.').last,
        'message': recommendation.message,
        'severity': recommendation.severity.toString().split('.').last,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
      });
    } catch (e) {
      print('Error saving alert to database: $e');
    }
  }
}