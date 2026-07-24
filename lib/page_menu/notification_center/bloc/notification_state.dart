import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final List<Map<String, dynamic>> notifications;
  
  const NotificationState({
    this.notifications = const [],
  });

  NotificationState copyWith({
    List<Map<String, dynamic>>? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  @override
  List<Object> get props => [notifications];
}
