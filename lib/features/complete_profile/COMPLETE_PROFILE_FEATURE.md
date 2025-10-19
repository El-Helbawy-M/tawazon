# Complete Profile Feature

## Overview
Enables a signed-in user to complete their profile if it is incomplete. The flow collects personal data and two survey forms (fetched from Firestore) that the user must fill before the app considers the profile complete.

## Business Purpose
- **Ensure profile completeness**: Capture demographic/academic attributes used across the app.
- **Collect survey responses**: Two questionnaires fetched dynamically from Firestore and stored for analytics/research.
- **Gate access**: Other features can require `hasCompletedProfile == true` to proceed.

## Architecture

### Core Models (`lib/features/complete_profile/core/models/`)
- **`CompleteProfileSubmissionParams`**: carries personal data fields for update.
  - Fields: `userId`, `selectedFaculity`, `gender`, `academicTeam`, `placeOfResidence`, `age`, `academicGrade`, `hasVisitedDoctorOnce`.
- **`SurveyForm`**: represents a questionnaire shell with ordered questions.
  - Fields: `id`, `title`, `description`, `language`, `version`, `questions: List<SurveyQuestion>`.
- **`SurveyQuestion`**: one question with selectable options and local answer state.
  - Fields: `id`, `text`, `options: List<String>`, `order`, `answer?: SelectOption`, `hasError`, `error`.
  - Factory: `SurveyQuestion.fromFirebaseDoc(DocumentSnapshot)`.
- **`SurveysSubmissionParams`**: carries a map of formId -> List<SurveyQuestion> (answers).
  - Fields: `userId`, `answers: Map<String, List<SurveyQuestion>>`.

### Repository (`lib/features/complete_profile/core/repo/`)
- **`CompleteProfileRepoInterface`**
  - `getSurveyForms() → Either<Failure, List<SurveyForm>>`
  - `submitAnswers({surveysParams, completeProfileParams}) → Either<Failure, bool>`

### Data (`lib/features/complete_profile/data/repo/`)
- **`CompleteProfileRepoImp`** (Firestore)
  - `getSurveyForms()`
    - Reads from `questionnaires` where `isActive == true`.
    - Validates header with `_isValidSurveyHeader` (checks `title`, `description`, `language`, `version`).
    - Loads ordered `questions` subcollection and maps to `SurveyQuestion`.
  - `submitAnswers(...)`
    - `_submitSurveys(SurveysSubmissionParams)` writes to `survey_responses/<userId>` with a nested map `{ <formId>: { <questionText>: <selectedValue> } }`.
    - `_submitCompleteProfile(CompleteProfileSubmissionParams)` updates `Users/<userId>` doc fields and sets `has_completed_profile = true`.

### UI (`lib/features/complete_profile/ui/`)
- **Bloc**: `ui/blocs/survey_forms_bloc.dart`
  - State type: `AppStates` (`LoadingState`, `LoadedState`, `ErrorState`).
  - Public events:
    - `getSurveyFormsEvent()` → loads forms on init.
    - `submitEvent()` → validates and persists surveys + personal data.
    - `updateEvent()` → emits updated forms for UI refresh.
  - Validation helpers:
    - `validateForm(formIndex)` ensures each `SurveyQuestion.answer` is set; toggles per-question errors.
    - `validatePersonalData()` validates faculty, academic team, age, grade, gender, residence.
  - Local state (selected values/controllers) for personal data.

- **Pages**
  - `ui/pages/complete_profile_page.dart`
    - Hosts a horizontal `Stepper` with the first step for personal data and subsequent steps for each loaded survey form.
    - On submit success shows snackbar and `Navigator.pop()`.
  - `ui/pages/personal_data_form.dart`
    - Renders personal data inputs using shared widgets: `SingleSelectInputField`, `RadioInputField`, `TextInputField`.
    - Writes user selections into `SurveyFormsCubit` fields/controllers.
  - `ui/pages/step_form.dart`
    - Renders a list of `ChoicesInputField` from `SurveyQuestion` instances; binds `question.answer`.

## Data Flow
1. `CompleteProfilePage` is opened with a provided `SurveyFormsCubit(repo: ...)`.
2. `SurveyFormsCubit` constructor calls `getSurveyFormsEvent()`.
3. Repo loads `questionnaires` and their `questions`; state becomes `LoadedState(forms)`.
4. User fills the first step (`PersonalDataForm`) and then each survey step.
5. On last step continue:
   - `validateForm()` must pass for the current survey.
   - `submitEvent()` constructs `SurveysSubmissionParams` and `CompleteProfileSubmissionParams` and calls `repo.submitAnswers()`.
6. On success:
   - Firestore writes survey responses and updates the user doc.
   - `UserCubit.instance.user.hasCompletedProfile = true` and `UserCubit.instance.updateEvent()`.
   - UI shows a success `SnackBar` and pops the screen.

## Validation
- **Personal data**: `validatePersonalData()` checks age (via `Validations.isValidAge`), grade non-empty, and required picks (faculty, academic team, gender, residence).
- **Survey steps**: `validateForm(formIndex)` enforces all questions must have `answer`.
- Errors are reflected per-question using `SurveyQuestion.hasError`/`error` and in fields via error strings in the cubit.

## Persistence (Firestore)
- Read questionnaires from:
  - Collection: `questionnaires`
  - Fields: `title`, `description`, `language`, `version`, `isActive`
  - Subcollection: `questions` ordered by `order` with fields `id?`, `text`, `options: List<String>`, `order`
- Write survey responses to:
  - Doc: `survey_responses/<userId>`
  - Shape: `{ <formId>: { <questionText>: <selectedValue> } }`
- Update user profile in:
  - Doc: `Users/<userId>`
  - Fields updated: `faculity`, `gender`, `academic_team`, `place_of_residence`, `academic_grade`, `age`, `has_visited_doctor_once`, `has_completed_profile`

## Dependencies
- `flutter_bloc`
- `cloud_firestore`
- `either_dart`

## Configuration Notes
- Requires Firebase configured (`google-services.json`/`GoogleService-Info.plist`).
- Ensure `UserCubit.instance.user.id` is available; the flow assumes a logged-in user.
- Localized strings via `TranslationKeys` and `TranslationHandler`.

## Edge Cases and UX
- Network errors during load/submit yield `ErrorState` or snackbar; consider retry affordances.
- Questionnaires with missing header or no questions are skipped by repo logic.
- Stepper navigation prevents advancing when current step is invalid.
- Personal data defaults: `gender` defaults to "ذكر", `placeOfResidence` defaults to "مدينة".

## Testing Guidelines
- **Cubit** (`SurveyFormsCubit`)
  - Loading path: emits `LoadingState` then `LoadedState(forms)` on success; `ErrorState` on failure.
  - `validatePersonalData()` returns false when required fields missing; updates error strings.
  - `validateForm()` flags questions without answers and triggers `updateEvent()`.
  - `submitEvent()` success path updates `UserCubit.user.hasCompletedProfile`, emits `LoadedState(forms, args: "submission")`.
- **Repository**
  - `getSurveyForms()` returns only valid forms; skips invalid headers or empty questions.
  - `submitAnswers()` writes both responses and user fields; handle `FirebaseException` and unknown exceptions.
- **Widgets**
  - `StepForm` binds selection to `SurveyQuestion.answer` and shows error when `hasError` is true.
  - `PersonalDataForm` propagates selections to cubit; numeric formatters for age/grade.

## Future Enhancements
- Add progress persistence for partially completed surveys.
- Server-driven required flags per question and richer types (multi-select, free-text, scales).
- Analytics events for step validation failures and completion.
- Dynamic value sets for personal data from Firestore.

## Related Components
- `lib/app/bloc/user_cubit.dart` for user context and profile completion flag.
- Shared input widgets under `lib/app/widgets/fields/`.
- Translations under `lib/config/app_translation_keys.dart` and `assets/lang/`.
