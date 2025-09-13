/// Enum representing the different states of a session
enum SessionStatus {
  /// Session has not been started yet
  notStarted('not_started', 'Not Started'),
  
  /// Session is currently in progress
  inProgress('in_progress', 'In Progress'),
  
  /// Session has been completed
  completed('completed', 'Finished');

  const SessionStatus(this.value, this.displayName);

  /// The string value used in the backend/database
  final String value;
  
  /// The display name shown to users
  final String displayName;

  /// Creates a SessionStatus from a string value
  static SessionStatus fromValue(String value) {
    switch (value) {
      case 'not_started':
        return SessionStatus.notStarted;
      case 'in_progress':
        return SessionStatus.inProgress;
      case 'completed':
        return SessionStatus.completed;
      default:
        return SessionStatus.notStarted;
    }
  }

  /// Gets all available session statuses
  static List<SessionStatus> get allStatuses => SessionStatus.values;

  @override
  String toString() => displayName;
}
