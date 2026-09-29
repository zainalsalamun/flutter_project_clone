import 'package:flutter/material.dart';
import 'basic_widget_category.dart';

class BasicWidgetProperty {
  final String name;
  final String type;
  final String description;
  final String defaultValue;

  const BasicWidgetProperty({
    required this.name,
    required this.type,
    required this.description,
    this.defaultValue = '-',
  });
}

class BasicWidgetModel {
  final String id;
  final String name;
  final BasicWidgetCategory category;
  final String summary;
  final String description;
  final IconData icon;
  final List<BasicWidgetProperty> keyProperties;
  final String codeSnippet;
  final List<String> usageTips;
  final Widget Function(BuildContext context) previewBuilder;

  const BasicWidgetModel({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    required this.description,
    required this.icon,
    required this.keyProperties,
    required this.codeSnippet,
    required this.usageTips,
    required this.previewBuilder,
  });
}
