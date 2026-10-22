# flutter_sonner

<p align="center">
  <b>An opinionated, beautifully stacked, spring-animated toast and notification package for Flutter.</b><br>
  Inspired by <a href="https://sonner.emilkowal.ski/">Sonner</a> by Emil Kowalski and Apple's Dynamic Island.
</p>

<p align="center">
  <img src="https://img.shields.io/pub/v/flutter_sonner.svg" alt="Pub Version">
  <img src="https://img.shields.io/pub/points/flutter_sonner" alt="Pub Points">
  <img src="https://img.shields.io/badge/platform-flutter%20%7C%20android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-blue" alt="Platforms">
  <img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License">
</p>

---

## ✨ Features

- 🃏 **Stacked Card Depth**: Automatically stacks consecutive toasts into a 3D perspective with realistic scale and shadow.
- 🪭 **Expandable on Tap or Hover**: Click or hover over the stack to smoothly fan out all pending notifications.
- 💨 **Smooth Gestures**: Native horizontal swipe-to-dismiss gesture support.
- ⚡ **Context-Free API**: Call `Sonner.success()` from anywhere—including BLOCs, controllers, services, and repositories—without passing `BuildContext`.
- 🔮 **Promise / Async Lifecycle**: `Sonner.promise()` manages loading states into success or error transitions seamlessly in a single card.
- 🏝️ **Dynamic Island Placement**: Place toasts at `topCenter` for a modern capsule style, or `bottomRight` for desktop/web.
- 🌓 **Automatic Dark / Light Mode**: Automatically adapts to system brightness or accepts custom `SonnerTheme`.
- 🪶 **Zero External Dependencies**: 100% pure Flutter SDK. No bloating, no version conflicts.

---

## 🚀 Quick Start

### 1. Add dependency

Add `flutter_sonner` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sonner: ^0.1.0
```

### 2. Wrap your MaterialApp

Initialize `Sonner.init()` inside `MaterialApp.builder`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_sonner/flutter_sonner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // 👈 Insert the Sonner builder here:
      builder: Sonner.init(
        position: SonnerPosition.bottomCenter,
      ),
      home: const HomeScreen(),
    );
  }
}
```

### 3. Trigger toasts from anywhere!

```dart
// Success toast
Sonner.success('Profile saved successfully!');

// Error toast with description
Sonner.error(
  'Payment failed',
  description: 'Please verify your billing details.',
);

// Info & Warning
Sonner.info('Update v2.0 is now available.');
Sonner.warning('Storage is almost full.');
```

---

## 🔮 Promise & Async Handler

Eliminate messy loading state booleans. Pass your `Future` directly to `Sonner.promise`:

```dart
Sonner.promise(
  authService.signIn(email, password),
  loading: 'Signing you in...',
  success: (user) => 'Welcome back, ${user.displayName}!',
  error: (err) => 'Authentication failed: $err',
);
```

---

## 🎯 Action Buttons & Customization

### Toast with an "Undo" action:
```dart
Sonner.show(
  'Message moved to trash',
  action: SonnerAction(
    label: 'Undo',
    onClick: () {
      messageService.restore();
      Sonner.success('Restored message');
    },
  ),
);
```

### Dynamic Island Style (Top-Center Placement):
```dart
Sonner.init(
  position: SonnerPosition.topCenter,
)
```

Available positions:
- `SonnerPosition.topCenter` (Dynamic Island style)
- `SonnerPosition.topLeft`
- `SonnerPosition.topRight`
- `SonnerPosition.bottomCenter` (Default mobile style)
- `SonnerPosition.bottomLeft`
- `SonnerPosition.bottomRight` (Recommended for Web / Desktop)

---

## 🎨 Theming

You can completely customize colors, shadows, radius, and stack physics via `SonnerTheme`:

```dart
Sonner.init(
  theme: const SonnerTheme(
    cardWidth: 380.0,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    scaleStep: 0.06,      // Scale depth delta
    collapsedOffset: 12.0, // Vertical tuck distance
    enableHapticFeedback: true,
  ),
)
```

---

## 📋 API Reference

| Method | Description |
|---|---|
| `Sonner.init({theme, position})` | Initializes the root overlay layer in `MaterialApp.builder` |
| `Sonner.show(title, ...)` | Displays a standard neutral toast |
| `Sonner.success(title, ...)` | Displays a success toast with emerald check icon |
| `Sonner.error(title, ...)` | Displays an error toast with crimson alert icon |
| `Sonner.info(title, ...)` | Displays an info toast with blue badge |
| `Sonner.warning(title, ...)` | Displays a warning toast with amber alert icon |
| `Sonner.loading(title, ...)` | Displays a persistent toast with spinning loader |
| `Sonner.promise(future, ...)` | Reactively updates from loading to success or error |
| `Sonner.custom(builder)` | Renders a fully customized widget inside the stack |
| `Sonner.dismiss(id)` | Dismisses a specific toast by its ID |
| `Sonner.dismissAll()` | Clears all active toasts |
| `Sonner.setPosition(position)` | Changes placement position dynamically |

---

## 📄 License

MIT License © 2026 Zainal Salamun. See [LICENSE](LICENSE) for details.
