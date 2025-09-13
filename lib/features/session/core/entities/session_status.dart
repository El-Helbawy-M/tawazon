/// Enum representing the different states of a session
enum EnumSessionStatus {
  /// Session has not been started yet
  notStarted('not_started', 'Not Started'),
  
  /// Session is currently in progress
  inProgress('in_progress', 'In Progress'),
  
  /// Session has been completed
  completed('completed', 'Finished');

  const EnumSessionStatus(this.value, this.displayName);

  /// The string value used in the backend/database
  final String value;
  
  /// The display name shown to users
  final String displayName;

  /// Creates a SessionStatus from a string value
  static EnumSessionStatus fromValue(String value) {
    switch (value) {
      case 'not_started':
        return EnumSessionStatus.notStarted;
      case 'in_progress':
        return EnumSessionStatus.inProgress;
      case 'completed':
        return EnumSessionStatus.completed;
      default:
        return EnumSessionStatus.notStarted;
    }
  }

  /// Gets all available session statuses
  static List<EnumSessionStatus> get allStatuses => EnumSessionStatus.values;

  @override
  String toString() => displayName;
}
