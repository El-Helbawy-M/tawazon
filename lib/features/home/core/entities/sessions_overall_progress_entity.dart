import 'package:cloud_firestore/cloud_firestore.dart';
import 'session_progress_entity.dart';

/// Entity representing the overall progress of all sessions for a user
class SessionsOverallProgressEntity {
  final String userId;
  final Map<String, SessionProgressEntity> sessions;
  final int totalSessions;
  final int completedSessions;
  final int inProgressSessions;
  final Timestamp lastActivity;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const SessionsOverallProgressEntity({
    required this.userId,
    required this.sessions,
    required this.totalSessions,
    required this.completedSessions,
    required this.inProgressSessions,
    required this.lastActivity,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Sorts sessions map by session ID and converts to SessionProgressEntity objects
  static Map<String, SessionProgressEntity> sortSessions(Map<String, dynamic> sessionsMap) {
    final sessions = <String, SessionProgressEntity>{};
    final sortedSessionEntries = sessionsMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    for (final entry in sortedSessionEntries) {
      if (entry.value is Map<String, dynamic>) {
        sessions[entry.key] = SessionProgressEntity.fromMap(entry.key, entry.value);
      }
    }
    
    return sessions;
  }

  /// Creates a SessionsOverallProgressEntity from Firestore document data
  factory SessionsOverallProgressEntity.fromMap(Map<String, dynamic> map) {
    final sessionsMap = map['sessions'] as Map<String, dynamic>? ?? {};
    final overallProgress = map['overallProgress'] as Map<String, dynamic>? ?? {};
    
    // Convert sessions map to SessionProgressEntity objects with sorting
    final sessions = sortSessions(sessionsMap);

    return SessionsOverallProgressEntity(
      userId: map['userId'] as String? ?? '',
      sessions: sessions,
      totalSessions: overallProgress['totalSessions'] as int? ?? 0,
      completedSessions: overallProgress['completedSessions'] as int? ?? 0,
      inProgressSessions: overallProgress['inProgressSessions'] as int? ?? 0,
      lastActivity: overallProgress['lastActivity'] as Timestamp? ?? Timestamp.now(),
      createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: map['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  /// Converts the entity to a map for Firestore storage
  Map<String, dynamic> toMap() {
    final sessionsMap = <String, dynamic>{};
    sessions.forEach((sessionId, sessionEntity) {
      sessionsMap[sessionId] = sessionEntity.toMap();
    });

    return {
      'userId': userId,
      'sessions': sessionsMap,
      'overallProgress': {
        'totalSessions': totalSessions,
        'completedSessions': completedSessions,
        'inProgressSessions': inProgressSessions,
        'lastActivity': lastActivity,
      },
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Gets a specific session progress by session ID
  SessionProgressEntity? getSessionProgress(String sessionId) {
    return sessions[sessionId];
  }

  /// Gets all completed sessions
  List<SessionProgressEntity> get completedSessionsList {
    return sessions.values
        .where((session) => session.status == 'completed')
        .toList();
  }

  /// Gets all in-progress sessions
  List<SessionProgressEntity> get inProgressSessionsList {
    return sessions.values
        .where((session) => session.status == 'in_progress')
        .toList();
  }

  /// Gets all not-started sessions
  List<SessionProgressEntity> get notStartedSessionsList {
    return sessions.values
        .where((session) => session.status == 'not_started')
        .toList();
  }

  /// Gets sessions sorted by session ID
  List<SessionProgressEntity> get sessionsSortedById {
    final sessionsList = sessions.entries.toList();
    sessionsList.sort((a, b) => a.key.compareTo(b.key));
    return sessionsList.map((entry) => entry.value).toList();
  }

  /// Calculates the overall completion percentage
  double get completionPercentage {
    if (totalSessions == 0) return 0.0;
    return (completedSessions / totalSessions) * 100;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SessionsOverallProgressEntity &&
      other.userId == userId &&
      other.totalSessions == totalSessions &&
      other.completedSessions == completedSessions &&
      other.inProgressSessions == inProgressSessions &&
      other.lastActivity == lastActivity;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      totalSessions.hashCode ^
      completedSessions.hashCode ^
      inProgressSessions.hashCode ^
      lastActivity.hashCode;
  }

  @override
  String toString() {
    return 'SessionsOverallProgressEntity(userId: $userId, totalSessions: $totalSessions, completedSessions: $completedSessions, inProgressSessions: $inProgressSessions, completionPercentage: ${completionPercentage.toStringAsFixed(1)}%)';
  }
}
