import 'package:flutter/material.dart';

/// Model metric statistics for AI Models
class LlmModelStat {
  final String id;
  final String name;
  final String provider;
  final int totalTokens;
  final double cost;
  final int avgLatencyMs;
  final double successRate;
  final Color color;
  final IconData icon;

  const LlmModelStat({
    required this.id,
    required this.name,
    required this.provider,
    required this.totalTokens,
    required this.cost,
    required this.avgLatencyMs,
    required this.successRate,
    required this.color,
    required this.icon,
  });
}

/// Cloud cluster region latency and health
class CloudRegionStat {
  final String regionCode;
  final String locationName;
  final String countryFlag;
  final int pingMs;
  final double throughputRps;
  final String status; // 'Operational', 'Degraded', 'Maintenance'
  final Color statusColor;

  const CloudRegionStat({
    required this.regionCode,
    required this.locationName,
    required this.countryFlag,
    required this.pingMs,
    required this.throughputRps,
    required this.status,
    required this.statusColor,
  });
}

/// Autonomous AI Agent task running in the cloud
class AiAgentTask {
  final String id;
  final String name;
  final String model;
  final String status; // 'Running', 'Completed', 'Paused', 'Failed'
  final double progress;
  final int tokensConsumed;
  final double runtimeSeconds;
  final DateTime startedAt;

  const AiAgentTask({
    required this.id,
    required this.name,
    required this.model,
    required this.status,
    required this.progress,
    required this.tokensConsumed,
    required this.runtimeSeconds,
    required this.startedAt,
  });

  AiAgentTask copyWith({String? status, double? progress}) {
    return AiAgentTask(
      id: id,
      name: name,
      model: model,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      tokensConsumed: tokensConsumed,
      runtimeSeconds: runtimeSeconds,
      startedAt: startedAt,
    );
  }
}

/// Time-series data point for token & cost charts
class TokenTimeSeriesPoint {
  final String timeLabel;
  final double gptTokens;
  final double claudeTokens;
  final double geminiTokens;
  final double totalCostUsd;

  const TokenTimeSeriesPoint({
    required this.timeLabel,
    required this.gptTokens,
    required this.claudeTokens,
    required this.geminiTokens,
    required this.totalCostUsd,
  });
}
