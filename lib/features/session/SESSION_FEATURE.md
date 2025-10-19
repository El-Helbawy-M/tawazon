# Session Feature

## Overview
The Session feature orchestrates guided therapy sessions with multiple steps, input validation, progress tracking, and completion flow persisted to Firestore.

## Business Purpose
- **Structured delivery** of therapeutic content step-by-step
- **Progress tracking** across steps and input items
- **Validation** for quiz steps (required inputs)
- **Completion flow** with backend persistence and user feedback dialog

## Architecture

### Core Components (`lib/features/session/core/`)

- **Entities** (`entities/`)
  - `SessionEntity`: `id`, `title`, `description`, `steps: List<SessionStepEntity>`, `currentStep`, `status: EnumSessionStatus`, `createdAt`, `completedAt?`
  - `SessionStepEntity`: `id`, `title`, `contentItems: List<ContentItemEntity>`, `type: SessionStepType`, `metadata?`, `isCompleted`
  - `ContentItemEntity`: `id`, `type: ContentType`, `content`, `caption?`, `metadata?`
    - Factories: `text`, `image`, `video`, `inputText(required?)`, `inputLongText(required?)`, `singleSelect(required?)`
  - `EnumSessionStatus`: `notStarted`, `inProgress`, `completed`
  - `SessionStepType`: `introduction`, `content`, `summary`, `conclusion`, `quiz`

- **Use Cases** (`usecases/`)
  - `GetSession` → load a session and current step/progress
  - `CompleteSessionStep` → mark current step completed, increment progress, persist user progress
  - `CompleteSession` → mark the entire session as completed in Firestore, set completedScreens = total steps, set status = completed, set completedAt

- **Hard-coded Content** (`sessions_hard_coded_content/`)
  - Example steps for sessions used during development and testing; quiz items may specify `required: true`

### UI Layer (`lib/features/session/ui/`)

- **Page**
  - `SessionPage`: Provides `SessionBloc`, renders content and controls, listens to completion to show congratulation dialog and pop back

- **Widgets** (`widgets/`)
  - `SessionStepContent`: Renders current step inside a `Form` (receives `formKey`) so nested inputs can be validated together
  - `ContentItemWidgets/`:
    - `InputTextContentWidget` and `InputLongTextContentWidget` read `metadata['required']` and register validators to enforce non-empty values
    - `SingleSelectContentWidget` wraps the picker in a `FormField` and validates selection when `metadata['required'] == true`
    - `TextContentWidget`, `ImageContentWidget`, `VideoContentWidget` are display-only
  - `SessionNavigationControls`: Next/Previous/Finish bar; on last step + `quiz`, validates the `formKey` before proceeding. On last step success, calls `SessionBloc.completeSession()`
  - `SessionProgressBar`: Visual progress

- **BLoC** (`ui/bloc/session_bloc.dart`)
  - Public API: `loadSession(sessionId, completedScreenCount)`, `nextStep()`, `previousStep()`, `completeSession()`
  - Events: `_SessionLoadEvent`, `_SessionNextStepEvent`, `_SessionPreviousStepEvent`, `_SessionCompleteEvent`
  - States: `InitialState`, `LoadingState`, `ErrorState(message)`, `_SessionLoadedState(session)`, `SessionCompletedState(session)`
  - Behavior:
    - `loadSession` → `GetSession`
    - `nextStep` → completes current step via `CompleteSessionStep` then moves forward
    - `previousStep` → moves back one step locally
    - `completeSession` → `CompleteSession` then emits `SessionCompletedState`

## Data Flow
1. User opens a session (`SessionPage`) → `SessionBloc.loadSession`
2. `GetSession` returns `SessionEntity` → `_SessionLoadedState`
3. `SessionStepContent` renders current step inside a `Form`
4. User interacts with inputs (validators attached when `required: true`)
5. Navigation:
   - Previous: moves back if `canGoPrevious`
   - Next: `CompleteSessionStep` then emit updated session
   - Finish (last step): if `quiz`, validates `formKey`; on success, `completeSession`
6. On `SessionCompletedState` → `SessionPage` shows congratulation `AlertDialog`; when dismissed, `Navigator.pop()` to return to previous screen

## Validation
- Required fields are driven by `ContentItemEntity.metadata['required']`
- Supported validators:
  - `inputText`, `inputLongText` → non-empty checks
  - `singleSelect` → selection must be made (via `FormField`)
- `SessionStepContent` must be wrapped with a shared `GlobalKey<FormState>` passed to both content and navigation controls

## Completion and Persistence
- `CompleteSessionStep` updates user progress (completedScreens) and marks step completed locally, then persists progress
- `CompleteSession` updates Firestore:
  - `sessions.<id>.screenProgress.completedScreens = steps.length`
  - `sessions.<id>.status = completed`
  - `sessions.<id>.completedAt = now`, `updatedAt = now`
- UI shows congratulation dialog; after dialog is dismissed, the session screen pops

## Dependencies
- `flutter_bloc`, `equatable`
- `dartz`
- `cloud_firestore`

## Testing Guidelines
- BLoC
  - Loading → Loaded path via `GetSession`
  - `nextStep()` → emits updated session or `ErrorState`
  - `completeSession()` → emits `SessionCompletedState` on success
- Use cases
  - `CompleteSessionStep` updates progress correctly
  - `CompleteSession` writes expected fields to Firestore
- Widgets
  - Form validation blocks Finish on last `quiz` until required fields are set
  - Completion dialog appears and screen pops after dismissal

## Future Enhancements
- Offline-first caching of sessions and progress
- Richer quiz types and validation rules
- Analytics on progress and completion
- Localized strings for all validation and dialog messages

## Related Components
- Authentication and `UserCubit` for user context
- Home flow: blocks navigating to session if profile is incomplete
