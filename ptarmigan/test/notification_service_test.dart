import 'package:flutter/cupertino.dart';
import 'package:ptarmigan/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
}

void Test_null_fields() {
  try {
    NotificationService().showNotification(null, null);
  } catch (e) {
    print(e);
  }
}

void Test_static_field()
{
  
}

