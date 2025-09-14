# 📱 Project Overview Template

This document serves as a reusable template for documenting Flutter projects.  
Fill in each section with project-specific details to provide clear context for developers and AI assistants.

---

## 🚀 Project Name
> Razeen Cast

---

## 🎯 Purpose
> Razeen mobile app is an extension of Razeen platform, designed for judges and experts to easily view, evaluate, and review submissions on the go. With its user-friendly interface, the app simplifies the process of filtering and assessing data based on customized criteria, ensuring a smooth and efficient experience. Whether you’re reviewing submissions or tracking progress, Razeen app makes the evaluation process simple and effective.

---

## ✨ Core Features
- [View Platforms] Feature 1 – list of assigned platforms to the user
- [View Programs] Feature 2 – list of assigned programs based on the selected platform
- [View Program Details] Feature 3 – view the details of the selected program
- [View Submissions] Feature 4 - list of submissions of the selected program and filter these submission by (name, status, Funnel Id)
- [View Submission Details] Feature 5 - view the answers of the submission
- [Evaluate Submission] Feature 6 - fill form of evaluation for the selected submission based on the selected funnel
- [View Funnels Summary] Feature 7 - list of funnels and the average score of each funnel based on the selected submission
- [View Activities] Feature 8 - list of activities contain (actions notification, messages, sent messages by the user itself)
- [Settings] Feature 9 - user can change the language between (Arabic <=> English), change it's name and logout
- [Authentication] Feature 10 - use can login by it's phone number and set the sent OTP 
---

## 🛠️ Tech Stack
- **Flutter Version:** 3.35.2 
- **Dart Version:** 3.9.0
- **State Management:** BloC
- **Navigation:** onGenerateRoute  
- **API Client:** Dio

---

## 🏗️ Architecture
- **Pattern Used:** Clean Architecture, MVVM, Repo Pattern, Singleton Pattern
- **Folder Structure:**  
lib/
├── app/                    # App-level components
│   ├── bloc/              # Global BLoCs (theme, auth, etc.)
│   ├── models/            # App-wide models
│   └── widgets/           # Global reusable widgets
├── configurations/        # App configs, colors, constants
├── core/                 # Core utilities, extensions, validations
├── features/             # Feature modules (self-contained)
├── handlers/             # Utility handlers (security, preferences)
├── navigation/           # Route management and navigation
├── network/              # Network layer and API services
└── main.dart
