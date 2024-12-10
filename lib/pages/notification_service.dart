import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String oneSignalAppId =
      'cfff0b1f-6268-454c-8218-7db471934533'; // Tu App ID de OneSignal
  static const String restApiKey =
      'os_v2_app_z77qwh3cnbcuzaqypw2hde2fgpgld3z6zcneukuh3x2d5rstmmhsqguup37mme44dlzsn56mtczjup2ckmgnjewnmnzd2d7cb5erkdy'; // Tu REST API Key de OneSignal

  // Método para enviar notificación push
  static Future<void> sendNotification({
    required String title,
    required String content,
    String? userId,
    Map<String, dynamic>? additionalData, // Campo opcional para datos adicionales
  }) async {
    var url = Uri.parse('https://onesignal.com/api/v1/notifications');

    var body = jsonEncode({
      "app_id": oneSignalAppId,
      "headings": {"en": title},
      "contents": {"en": content},
      "small_icon": "ic_stat_onesignal_default", // Puedes personalizar el ícono
      if (userId != null) "include_external_user_ids": [userId],
      if (userId == null) "included_segments": ["All"],
      if (additionalData != null) "data": additionalData, // Aquí añades los datos adicionales
    });

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic $restApiKey',
    };

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notificación enviada: $title');
      } else {
        print('Error enviando notificación: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

