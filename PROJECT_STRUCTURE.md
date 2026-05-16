# PrepYou.ai Flutter App

A modern AI-powered interview coaching application built with Flutter, matching the PrepYou.ai design.

## Project Structure

```
lib/
├── main.dart                 # App entry point with theme setup
├── theme/
│   └── app_theme.dart       # Dark theme configuration with teal accent colors
├── screens/
│   └── home_screen.dart     # Main dashboard screen with navigation
└── widgets/
    ├── coach_card.dart           # AI Coach welcome card with action buttons
    ├── progress_section.dart     # User progress statistics
    ├── quick_access_section.dart # Quick access grid for interview types
    ├── interview_list_section.dart # Recent interviews list
    └── credits_section.dart      # AI credits display and upgrade button
```

## Features

- **Dark Theme**: Modern dark interface with teal (#00D9A3) accent colors
- **AI Coach Card**: Welcome section with call-to-action buttons
- **Progress Tracking**: Display of sessions completed, average score, and streak
- **Quick Access**: Grid for MCQ Exam, HR Interview, Tech Interview, and Final Report
- **Recent Interviews**: List of past interview sessions with scores
- **Credits System**: AI credits tracking with upgrade option
- **Bottom Navigation**: Navigate between Home, Saved, History, and Settings

## Color Scheme

- **Primary Color**: #00D9A3 (Teal)
- **Background**: #0F1419 (Dark)
- **Surface**: #1A1F2E (Dark Gray)
- **Border**: #2A3142 (Light Gray)
- **Text Primary**: White
- **Text Secondary**: Gray

## Getting Started

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Files Overview

### main.dart
Entry point of the application. Sets up the MaterialApp with the dark theme and loads the HomeScreen.

### theme/app_theme.dart
Centralized theme configuration including:
- Color constants
- Text styles
- Button styling
- Navigation bar appearance

### screens/home_screen.dart
Main dashboard screen that orchestrates all widgets and handles bottom navigation state.

### widgets/
Collection of reusable widgets that make up the dashboard:

- **coach_card.dart**: Displays AI coach greeting with "Start New Session" and "Continue Pipeline" buttons
- **progress_section.dart**: Shows statistics in card layout (Sessions, Avg Score, Best Streak)
- **quick_access_section.dart**: 2x2 grid of interview type options
- **interview_list_section.dart**: Scrollable list of recent interviews with dates and scores
- **credits_section.dart**: Credits balance display with upgrade button

## Customization

All colors are defined in `theme/app_theme.dart` for easy modification. Each widget is self-contained and can be easily customized or replaced.

