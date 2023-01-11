import 'package:ecommerce_user/db/db_helper.dart';
import 'package:ecommerce_user/models/notification_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  Future<void> addNotification(NotificationModel notificationModel) {
    return DbHelper.addNotification(notificationModel);
  }

}

