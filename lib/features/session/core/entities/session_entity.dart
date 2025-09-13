import 'session_step_entity.dart';
import 'session_status.dart';

/// Session entity representing a training session with multiple steps
class SessionEntity {
  final String id;
  final String title;
  final String description;
  final List<SessionStepEntity> steps;
  final int currentStep;
  final EnumSessionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const SessionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    required this.currentStep,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  SessionEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<SessionStepEntity>? steps,
    int? currentStep,
    EnumSessionStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  double get progress => steps.isEmpty ? 0.0 : (currentStep + 1) / steps.length;
  
  bool get isCompleted => status == EnumSessionStatus.completed;
  
  bool get canGoNext => currentStep < steps.length - 1;
  
  bool get canGoPrevious => currentStep > 0;
}

