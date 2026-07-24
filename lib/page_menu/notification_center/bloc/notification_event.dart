import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final int id;

  const MarkNotificationAsRead(this.id);

  @override
  List<Object> get props => [id];
}

class MarkAllNotificationsAsRead extends NotificationEvent {}
