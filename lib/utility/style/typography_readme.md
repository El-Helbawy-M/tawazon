# 🖋️ AppTypography – Usage Reference Guide

This guide shows exactly where to use each text style (`AppTypography`) in your Flutter UI components. These styles are aligned with Flutter’s `TextTheme`.

---

## ✅ Recommended Usage per Style

| Text Style           | Flutter Name            | Use in Components / Widgets                                     |
|----------------------|--------------------------|------------------------------------------------------------------|
| **displayLarge**     | `TextTheme.displayLarge` | Big screen titles, onboarding headers, dashboard top titles     |
| **displayMedium**    | `TextTheme.displayMedium`| Large section titles, tab headers, hero banners                 |
| **displaySmall**     | `TextTheme.displaySmall` | Card headers, dialog titles, feature titles                     |
| **headlineLarge**    | `TextTheme.headlineLarge`| Blog post titles, profile section headers                       |
| **headlineMedium**   | `TextTheme.headlineMedium`| Card section headers, alerts                                     |
| **headlineSmall**    | `TextTheme.headlineSmall`| Stepper titles, smaller card subtitles                          |
| **titleLarge**       | `TextTheme.titleLarge`   | ListTile titles, form section headers                           |
| **titleMedium**      | `TextTheme.titleMedium`  | Section subtitles, filter titles                                |
| **titleSmall**       | `TextTheme.titleSmall`   | Captions under images, small section labels                     |
| **bodyLarge**        | `TextTheme.bodyLarge`    | Main content body (paragraphs, list items)                      |
| **bodyMedium**       | `TextTheme.bodyMedium`   | Secondary text in cards, hints, non-primary labels              |
| **bodySmall**        | `TextTheme.bodySmall`    | Tiny notes, timestamps, small explanations                      |
| **labelLarge**       | `TextTheme.labelLarge`   | Button text, form labels, tab names                             |
| **labelMedium**      | `TextTheme.labelMedium`  | TextField hints, icon labels, FAB text                          |
| **labelSmall**       | `TextTheme.labelSmall`   | Metadata, tags, counters, badge labels                          |

---

## 🔍 Example Usages (Widgets)

```dart
// ✅ displayLarge for screen title
Text(
  'Welcome to Sushi Crush',
  style: Theme.of(context).textTheme.displayLarge,
);

// ✅ bodyMedium for card subtitle
Card(
  child: ListTile(
    title: Text('Order #123'),
    subtitle: Text(
      'Preparing...',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  ),
);

// ✅ labelLarge for button
ElevatedButton(
  onPressed: () {},
  child: Text(
    'Confirm',
    style: Theme.of(context).textTheme.labelLarge,
  ),
);

// ✅ bodySmall for timestamp
Text(
  'Updated 5 mins ago',
  style: Theme.of(context).textTheme.bodySmall,
);
