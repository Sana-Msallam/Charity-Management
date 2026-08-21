sealed class NotificationsBadgeState {
  const NotificationsBadgeState();
}

class NotificationsBadgeInitial extends NotificationsBadgeState {
  const NotificationsBadgeInitial();
}

class NotificationsBadgeLoaded extends NotificationsBadgeState {
  const NotificationsBadgeLoaded(this.unreadCount);

  final int unreadCount;
}

class NotificationsBadgeHidden extends NotificationsBadgeState {
  const NotificationsBadgeHidden();
}
