import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) {
    // Initial dummy data
    final notifications = [
      {
        'id': 1,
        'title': 'New Update Available',
        'message': 'Version 2.0 is out now. Tap to see the new features and improvements.',
        'time': '10 mins ago',
        'isRead': false,
        'icon': Icons.system_update,
        'color': Colors.blue,
      },
      {
        'id': 2,
        'title': 'Payment Successful',
        'message': 'Your subscription has been renewed successfully for the next month.',
        'time': '1 hour ago',
        'isRead': false,
        'icon': Icons.payment,
        'color': Colors.green,
      },
      {
        'id': 3,
        'title': 'Security Alert',
        'message': 'New login detected from a new device in Jakarta, Indonesia.',
        'time': '3 hours ago',
        'isRead': false,
        'icon': Icons.security,
        'color': Colors.red,
      },
      {
        'id': 4,
        'title': 'Welcome to the App!',
        'message': 'Thanks for joining us. We are excited to have you on board.',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.waving_hand,
        'color': Colors.orange,
      },
    ];
    emit(state.copyWith(notifications: notifications));
  }

  void _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) {
    final updatedNotifications = state.notifications.map((notif) {
      if (notif['id'] == event.id) {
        return {...notif, 'isRead': true};
      }
      return notif;
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }

  void _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) {
    final updatedNotifications = state.notifications.map((notif) {
      return {...notif, 'isRead': true};
    }).toList();
    emit(state.copyWith(notifications: updatedNotifications));
  }
}
