# PrepYou.ai - Updated Project Structure

A modern AI-powered interview coaching application built with Flutter, using Clean Architecture and BLoC for state management.

## Project Structure Overview

The project is structured under the `lib/` directory using feature-first separation, with layers representing Clean Architecture boundaries.

```
lib/
├── core/                       # Shared infrastructure & utilities
│   ├── api/                    # Dio HTTP client & API endpoints config
│   ├── services/               # Secure storage services (JWT management)
│   └── widgets/                # Reusable global widgets (App Bar, Bottom Nav)
├── features/                   # Core application features (Clean Arch modules)
│   ├── auth/                   # Authentication data, domain & usecases
│   ├── cv_report/              # CV parsing and skill-matching analysis
│   ├── final_report/           # Cumulative scores, AI feedback & shared links
│   ├── hr_interview/           # HR Mock voice and chat interview interface
│   ├── interview_session/      # Manage session history & pipeline statuses
│   ├── mcq_complete/           # MCQ test result score rings and review UI
│   ├── mcq_exam/               # Interactive MCQ exam screen & options selector
│   ├── questions/              # Data model & usecases for master questions list
│   ├── skills/                 # Skills tracking entities & repositories
│   └── tech_interview/         # Technical Mock interview with built-in code editor
├── screens/                    # Global app routing screens & dashboard layouts
│   ├── auth_screen.dart        # Entry screen containing Sign In & Sign Up tabs
│   ├── home_screen.dart        # Main dashboard home tab
│   ├── login_screen.dart       # User login interface
│   ├── main_dashboard.dart     # Outer layout orchestrating main tab navigations
│   ├── pipeline_screen.dart    # Roadmap screen showing candidate's current stage status
│   ├── signup_screen.dart      # User signup interface
│   └── splash_screen.dart      # Interactive launch splash screen
├── services/                   # Global background/helper services
│   └── auth_service.dart
├── theme/                      # Styling & layout configurations
│   └── app_theme.dart          # Dark mode neon configurations
└── main.dart                   # Application entry point with router setup
```

## Clean Architecture Layers per Feature

Each feature directory inside `lib/features/` is split into:
*   **`data`**: Contains network models (DTOs), remote/local data sources, and the repository implementations converting models to entity domain objects.
*   **`domain`**: Contains the pure business logic: entities (data representations without Flutter references), usecases (single-responsibility operations), and repository contracts/interfaces.
*   **`presentation`**: BLoCs/Cubits managing state, pages displaying UI components, and custom widgets used on those pages.

## Test Suites

The project contains unit and repository implementation test suites under the `test/` directory, mirroring the clean architecture layers:
*   `test/features/cv_report/cv_report_repository_impl_test.dart`
*   `test/features/final_report/final_report_repository_impl_test.dart`
*   `test/features/hr_interview/hr_interview_repository_impl_test.dart`
*   `test/features/interview_session/session_test.dart`
*   `test/features/mcq_complete/mcq_complete_repository_impl_test.dart`
*   `test/features/mcq_exam/mcq_exam_repository_impl_test.dart`
*   `test/features/questions/questions_test.dart`
*   `test/features/skills/skills_test.dart`
*   `test/features/tech_interview/tech_interview_repository_impl_test.dart`
*   `test/widget_test.dart`

Run all tests via:
```bash
flutter test
```
