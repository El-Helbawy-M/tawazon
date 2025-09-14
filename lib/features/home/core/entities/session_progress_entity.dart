import 'package:cloud_firestore/cloud_firestore.dart';

/// Entity representing the progress of a single session
class SessionProgressEntity {
  final String sessionId;
  final String sessionName;
  final int totalScreens;
  final int completedScreens;
  final List<String> completedScreenIds;
  final Timestamp? lastCompletedAt;
  final Timestamp? startedAt;
  final String status; // 'not_started', 'in_progress', 'completed'

  const SessionProgressEntity({
    required this.sessionId,
    required this.sessionName,
    required this.totalScreens,
    required this.completedScreens,
    required this.completedScreenIds,
    this.lastCompletedAt,
    this.startedAt,
    required this.status,
  });

  /// Creates a SessionProgressEntity from Firestore document data
  factory SessionProgressEntity.fromMap(String sessionId, Map<String, dynamic> map) {
    final screenProgress = map['screenProgress'] as Map<String, dynamic>? ?? {};
    
    return SessionProgressEntity(
      sessionId: sessionId,
      sessionName: map['sessionName'] as String? ?? '',
      totalScreens: screenProgress['totalScreens'] as int? ?? 0,
      completedScreens: screenProgress['completedScreens'] as int? ?? 0,
      completedScreenIds: List<String>.from(screenProgress['completedScreenIds'] as List? ?? []),
      lastCompletedAt: screenProgress['lastCompletedAt'] as Timestamp?,
      startedAt: screenProgress['startedAt'] as Timestamp?,
      status: map['status'] as String? ?? 'not_started',
    );
  }

  /// Converts the entity to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'sessionName': sessionName,
      'screenProgress': {
        'totalScreens': totalScreens,
        'completedScreens': completedScreens,
        'completedScreenIds': completedScreenIds,
        'lastCompletedAt': lastCompletedAt,
        'startedAt': startedAt,
      },
      'status': status,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SessionProgressEntity &&
      other.sessionId == sessionId &&
      other.sessionName == sessionName &&
      other.totalScreens == totalScreens &&
      other.completedScreens == completedScreens &&
      other.lastCompletedAt == lastCompletedAt &&
      other.startedAt == startedAt &&
      other.status == status;
  }

  @override
  int get hashCode {
    return sessionId.hashCode ^
      sessionName.hashCode ^
      totalScreens.hashCode ^
      completedScreens.hashCode ^
      lastCompletedAt.hashCode ^
      startedAt.hashCode ^
      status.hashCode;
  }

  @override
  String toString() {
    return 'SessionProgressEntity(sessionId: $sessionId, sessionName: $sessionName, totalScreens: $totalScreens, completedScreens: $completedScreens, status: $status)';
  }
}
