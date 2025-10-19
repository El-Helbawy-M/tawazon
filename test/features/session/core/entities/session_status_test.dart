import 'package:flutter_test/flutter_test.dart';
import 'package:tawazon/features/session/core/entities/session_status.dart';

void main() {
  group('EnumSessionStatus', () {
    group('enum values', () {
      test('should have all expected enum values', () {
        expect(EnumSessionStatus.values, contains(EnumSessionStatus.notStarted));
        expect(EnumSessionStatus.values, contains(EnumSessionStatus.inProgress));
        expect(EnumSessionStatus.values, contains(EnumSessionStatus.completed));
      });

      test('should have correct number of enum values', () {
        expect(EnumSessionStatus.values.length, 3);
      });
    });

    group('constructor and properties', () {
      test('should have correct value and displayName for notStarted', () {
        expect(EnumSessionStatus.notStarted.value, 'not_started');
        expect(EnumSessionStatus.notStarted.displayName, 'Not Started');
      });

      test('should have correct value and displayName for inProgress', () {
        expect(EnumSessionStatus.inProgress.value, 'in_progress');
        expect(EnumSessionStatus.inProgress.displayName, 'In Progress');
      });

      test('should have correct value and displayName for completed', () {
        expect(EnumSessionStatus.completed.value, 'completed');
        expect(EnumSessionStatus.completed.displayName, 'Finished');
      });
    });

    group('fromValue factory method', () {
      test('should return notStarted for "not_started" value', () {
        final result = EnumSessionStatus.fromValue('not_started');
        expect(result, EnumSessionStatus.notStarted);
      });

      test('should return inProgress for "in_progress" value', () {
        final result = EnumSessionStatus.fromValue('in_progress');
        expect(result, EnumSessionStatus.inProgress);
      });

      test('should return completed for "completed" value', () {
        final result = EnumSessionStatus.fromValue('completed');
        expect(result, EnumSessionStatus.completed);
      });

      test('should return notStarted for unknown value', () {
        final result = EnumSessionStatus.fromValue('unknown_status');
        expect(result, EnumSessionStatus.notStarted);
      });

      test('should return notStarted for empty string', () {
        final result = EnumSessionStatus.fromValue('');
        expect(result, EnumSessionStatus.notStarted);
      });

      test('should return notStarted for null-like string', () {
        final result = EnumSessionStatus.fromValue('null');
        expect(result, EnumSessionStatus.notStarted);
      });

      test('should handle case sensitivity correctly', () {
        final result1 = EnumSessionStatus.fromValue('NOT_STARTED');
        final result2 = EnumSessionStatus.fromValue('In_Progress');
        final result3 = EnumSessionStatus.fromValue('COMPLETED');

        expect(result1, EnumSessionStatus.notStarted);
        expect(result2, EnumSessionStatus.notStarted);
        expect(result3, EnumSessionStatus.notStarted);
      });

      test('should handle whitespace in values', () {
        final result1 = EnumSessionStatus.fromValue(' not_started ');
        final result2 = EnumSessionStatus.fromValue('not_started\n');
        final result3 = EnumSessionStatus.fromValue('\tin_progress');

        expect(result1, EnumSessionStatus.notStarted);
        expect(result2, EnumSessionStatus.notStarted);
        expect(result3, EnumSessionStatus.notStarted);
      });
    });

    group('allStatuses static getter', () {
      test('should return all enum values', () {
        final allStatuses = EnumSessionStatus.allStatuses;
        
        expect(allStatuses.length, 3);
        expect(allStatuses, contains(EnumSessionStatus.notStarted));
        expect(allStatuses, contains(EnumSessionStatus.inProgress));
        expect(allStatuses, contains(EnumSessionStatus.completed));
      });

      test('should return the same list as EnumSessionStatus.values', () {
        final allStatuses = EnumSessionStatus.allStatuses;
        final enumValues = EnumSessionStatus.values;
        
        expect(allStatuses, equals(enumValues));
      });
    });

    group('toString method', () {
      test('should return displayName for notStarted', () {
        expect(EnumSessionStatus.notStarted.toString(), 'Not Started');
      });

      test('should return displayName for inProgress', () {
        expect(EnumSessionStatus.inProgress.toString(), 'In Progress');
      });

      test('should return displayName for completed', () {
        expect(EnumSessionStatus.completed.toString(), 'Finished');
      });
    });

    group('enum comparison and equality', () {
      test('should be equal to itself', () {
        expect(EnumSessionStatus.notStarted, equals(EnumSessionStatus.notStarted));
        expect(EnumSessionStatus.inProgress, equals(EnumSessionStatus.inProgress));
        expect(EnumSessionStatus.completed, equals(EnumSessionStatus.completed));
      });

      test('should not be equal to different enum values', () {
        expect(EnumSessionStatus.notStarted, isNot(equals(EnumSessionStatus.inProgress)));
        expect(EnumSessionStatus.inProgress, isNot(equals(EnumSessionStatus.completed)));
        expect(EnumSessionStatus.completed, isNot(equals(EnumSessionStatus.notStarted)));
      });

      test('should have consistent hashCode', () {
        final status1 = EnumSessionStatus.notStarted;
        final status2 = EnumSessionStatus.notStarted;
        
        expect(status1.hashCode, equals(status2.hashCode));
      });
    });

    group('usage in switch statements', () {
      test('should work correctly in switch statements', () {
        String getStatusDescription(EnumSessionStatus status) {
          switch (status) {
            case EnumSessionStatus.notStarted:
              return 'Session has not been started';
            case EnumSessionStatus.inProgress:
              return 'Session is currently running';
            case EnumSessionStatus.completed:
              return 'Session has been completed';
          }
        }

        expect(getStatusDescription(EnumSessionStatus.notStarted), 'Session has not been started');
        expect(getStatusDescription(EnumSessionStatus.inProgress), 'Session is currently running');
        expect(getStatusDescription(EnumSessionStatus.completed), 'Session has been completed');
      });
    });

    group('integration with collections', () {
      test('should work correctly in lists', () {
        final statusList = [
          EnumSessionStatus.notStarted,
          EnumSessionStatus.inProgress,
          EnumSessionStatus.completed,
        ];

        expect(statusList.length, 3);
        expect(statusList.contains(EnumSessionStatus.notStarted), true);
        expect(statusList.contains(EnumSessionStatus.inProgress), true);
        expect(statusList.contains(EnumSessionStatus.completed), true);
      });

      test('should work correctly in sets', () {
        final statusSet = {
          EnumSessionStatus.notStarted,
          EnumSessionStatus.inProgress,
          EnumSessionStatus.completed,
          EnumSessionStatus.notStarted, // Duplicate should be ignored
        };

        expect(statusSet.length, 3);
        expect(statusSet.contains(EnumSessionStatus.notStarted), true);
      });

      test('should work correctly as map keys', () {
        final statusMap = {
          EnumSessionStatus.notStarted: 'Not started yet',
          EnumSessionStatus.inProgress: 'Currently running',
          EnumSessionStatus.completed: 'All done',
        };

        expect(statusMap[EnumSessionStatus.notStarted], 'Not started yet');
        expect(statusMap[EnumSessionStatus.inProgress], 'Currently running');
        expect(statusMap[EnumSessionStatus.completed], 'All done');
      });
    });

    group('edge cases and robustness', () {
      test('should handle fromValue with special characters', () {
        final result1 = EnumSessionStatus.fromValue('not-started');
        final result2 = EnumSessionStatus.fromValue('in.progress');
        final result3 = EnumSessionStatus.fromValue('completed!');

        expect(result1, EnumSessionStatus.notStarted);
        expect(result2, EnumSessionStatus.notStarted);
        expect(result3, EnumSessionStatus.notStarted);
      });

      test('should handle fromValue with numeric strings', () {
        final result1 = EnumSessionStatus.fromValue('0');
        final result2 = EnumSessionStatus.fromValue('1');
        final result3 = EnumSessionStatus.fromValue('2');

        expect(result1, EnumSessionStatus.notStarted);
        expect(result2, EnumSessionStatus.notStarted);
        expect(result3, EnumSessionStatus.notStarted);
      });

      test('should handle fromValue with very long strings', () {
        final longString = 'a' * 1000;
        final result = EnumSessionStatus.fromValue(longString);
        
        expect(result, EnumSessionStatus.notStarted);
      });
    });
  });
}
