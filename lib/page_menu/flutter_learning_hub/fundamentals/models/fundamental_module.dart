import 'package:flutter/material.dart';

enum FundamentalModule {
  all(
    title: 'Semua Modul',
    icon: Icons.auto_stories_rounded,
    color: Color(0xFF6366F1),
    description: 'Seluruh materi dan konsep dasar hingga tingkat lanjut Flutter',
  ),
  dartBasics(
    title: 'Dart & OOP',
    icon: Icons.code_rounded,
    color: Color(0xFF0284C7),
    description: 'Tipe data, Null Safety, OOP, Mixin, Extensions',
  ),
  dartOop(
    title: 'Dart & OOP',
    icon: Icons.code_rounded,
    color: Color(0xFF0284C7),
    description: 'Tipe data, Null Safety, OOP, Mixin, Extensions',
  ),
  architecture(
    title: 'Widget Tree & Core',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF10B981),
    description: 'Widget, Element, RenderObject, BuildContext',
  ),
  widgetTree(
    title: 'Widget Tree & Core',
    icon: Icons.account_tree_rounded,
    color: Color(0xFF10B981),
    description: 'Widget, Element, RenderObject, BuildContext',
  ),
  lifecycle(
    title: 'Widget Lifecycle',
    icon: Icons.sync_rounded,
    color: Color(0xFFF59E0B),
    description: 'Stateless vs Stateful, alur initState hingga dispose',
  ),
  stateLifecycle(
    title: 'Widget Lifecycle & State',
    icon: Icons.sync_rounded,
    color: Color(0xFFF59E0B),
    description: 'Stateless vs Stateful, alur initState hingga dispose',
  ),
  layoutRules(
    title: 'Aturan Layout',
    icon: Icons.view_quilt_rounded,
    color: Color(0xFF8B5CF6),
    description: 'Constraints down, sizes up, bounded vs unbounded',
  ),
  layoutConstraints(
    title: 'Layout & Constraints',
    icon: Icons.view_quilt_rounded,
    color: Color(0xFF8B5CF6),
    description: 'Constraints down, sizes up, bounded vs unbounded',
  ),
  navigation(
    title: 'Navigasi & Routing',
    icon: Icons.alt_route_rounded,
    color: Color(0xFFEC4899),
    description: 'Navigator 1.0, 2.0, GoRouter, passing data',
  ),
  stateManagement(
    title: 'State Dasar',
    icon: Icons.dynamic_feed_rounded,
    color: Color(0xFF06B6D4),
    description: 'Ephemeral vs App State, setState, ValueNotifier',
  ),
  asyncNetworking(
    title: 'Async, Future & Stream',
    icon: Icons.cloud_sync_rounded,
    color: Color(0xFF14B8A6),
    description: 'Future, async/await, Stream, HTTP, JSON mapping',
  ),
  themingResponsive(
    title: 'Theming & Responsif',
    icon: Icons.palette_rounded,
    color: Color(0xFFE11D48),
    description: 'Material 3 ColorScheme, MediaQuery, LayoutBuilder',
  ),
  cleanArchitecture(
    title: 'Clean Architecture',
    icon: Icons.verified_rounded,
    color: Color(0xFF4F46E5),
    description: 'Folder structure, optimasi performa const, DevTools',
  ),
  architectureBestPractices(
    title: 'Architecture & Best Practices',
    icon: Icons.verified_rounded,
    color: Color(0xFF4F46E5),
    description: 'Folder structure, optimasi performa const, DevTools',
  ),
  networkingApi(
    title: 'REST API & Dio',
    icon: Icons.http_rounded,
    color: Color(0xFF2563EB),
    description: 'Dio, Interceptors, Bearer Token JWT, Error Handling',
  ),
  localStorage(
    title: 'Storage & Caching',
    icon: Icons.storage_rounded,
    color: Color(0xFFD97706),
    description: 'SharedPreferences, Hive NoSQL, SQLite/Drift, Offline Cache',
  ),
  advancedState(
    title: 'BLoC & Riverpod',
    icon: Icons.hub_rounded,
    color: Color(0xFF7C3AED),
    description: 'BLoC/Cubit Masterclass, Riverpod 2.x, AsyncNotifier',
  ),
  animationsCustomPainter(
    title: 'Animasi & Canvas',
    icon: Icons.brush_rounded,
    color: Color(0xFFDB2777),
    description: 'AnimationController, TweenSequence, CustomPainter Canvas',
  ),
  renderCustomPainter(
    title: 'Render & Custom Painter',
    icon: Icons.brush_rounded,
    color: Color(0xFFDB2777),
    description: 'AnimationController, TweenSequence, CustomPainter Canvas',
  ),
  testingQa(
    title: 'Testing & QA',
    icon: Icons.fact_check_rounded,
    color: Color(0xFF059669),
    description: 'Unit Testing, Mocking Logic, Widget Testing, Integration',
  );

  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const FundamentalModule({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}
