import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/diagnostics_bloc_state.dart';
import '../models/device_diagnostics_event.dart';
import '../models/display_and_sensors_data.dart';
import 'diagnostics_logger_service.dart';
import 'network_connectivity_service.dart';

class DiagnosticsReportService {
  static final DiagnosticsReportService instance =
      DiagnosticsReportService._internal();

  DiagnosticsReportService._internal();

  /// Generates a structured, beautifully formatted PDF document for Device Diagnostics
  Future<Uint8List> generatePdfReport({
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) async {
    final pdf = pw.Document();
    final nowFormatted =
        DateFormat('dd MMM yyyy, HH:mm:ss').format(event.timestamp.toLocal());
    final logs = DiagnosticsLoggerService.instance.logs.take(15).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPdfHeader(event, nowFormatted),
        footer: (context) => _buildPdfFooter(context),
        build: (context) => [
          pw.SizedBox(height: 12),

          // 1. Device Identification & Security Section
          _buildPdfSectionTitle("1. IDENTITAS PERANGKAT & KEAMANAN HARDWARE"),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            children: [
              _buildTableRow("Device Model", event.model, "Brand / Maker",
                  "${event.brand} (${event.manufacturer})"),
              _buildTableRow("Device Codename", event.device, "App Version",
                  "v${event.appVersion}"),
              _buildTableRow("OS Version", state.osVersion, "OS Build",
                  state.osBuild),
              _buildTableRow("User ID", event.userId, "Device Platform",
                  state.isEmulator ? "EMULATOR / VM" : "Fisik Asli (Real)"),
              _buildTableRow("Root / Jailbreak",
                  state.isRooted ? "ROOTED (Bahaya)" : "Clean (Not Rooted)",
                  "Developer Options",
                  state.isDeveloperMode ? "ON (Aktif)" : "OFF (Nonaktif)"),
              _buildTableRow("Fake GPS (Mock)",
                  state.isMockLocation ? "AKTIF (Mock)" : "Clean (Aman)",
                  "VPN / Proxy",
                  state.isVpnActive ? "VPN Aktif" : "Direct Link"),
              _buildTableRow("Biometrik Hardware",
                  state.hasBiometricHardware ? "Tersedia" : "Tidak Ada",
                  "Biometrik Enrolled",
                  state.isBiometricEnrolled ? "Terdaftar (OK)" : "Belum Didaftar"),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Hardware SHA-256 Device ID Hash:",
                    style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800)),
                pw.Text(event.deviceIdHash,
                    style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.blue900)),
                pw.SizedBox(height: 2),
                pw.Text("Installation ID Hash:",
                    style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800)),
                pw.Text(event.installationIdHash,
                    style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.blue900)),
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // 2. Hardware Telemetry, Memory & Battery
          _buildPdfSectionTitle("2. TELEMETRI HARDWARE, MEMORI & BATERAI"),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            children: [
              _buildTableRow(
                  "Battery Level",
                  "${event.batteryLevel}% (${event.batteryState.toUpperCase()})",
                  "Battery Temperature",
                  "${event.formattedBatteryTemp} (${event.batteryTempStatus})"),
              _buildTableRow(
                  "Battery Health",
                  event.batteryHealthLabel,
                  "Technology / Voltage",
                  "${event.batteryTechnology} • ${event.formattedVoltage}"),
              _buildTableRow(
                  "Power Saver Mode",
                  event.powerSaveModeLabel,
                  "Sisa / Total RAM",
                  "${event.formattedAvailableRam} / ${event.formattedTotalRam}"),
              _buildTableRow(
                  "RAM Terpakai",
                  event.formattedUsedRam,
                  "Sisa / Total Storage",
                  "${event.formattedAvailableStorage} / ${event.formattedTotalStorage}"),
              _buildTableRow(
                  "Storage Terpakai",
                  event.formattedUsedStorage,
                  "Network Transport",
                  state.networkInfo.connectionLabel),
              _buildTableRow(
                  "Koneksi Internet",
                  state.networkInfo.isOnline
                      ? "ONLINE (${state.networkInfo.latencyMs} ms)"
                      : "OFFLINE",
                  "IP Address",
                  state.networkInfo.ipAddress),
            ],
          ),
          pw.SizedBox(height: 14),

          // 3. Display Specs & Sensors Catalog
          _buildPdfSectionTitle("3. SPESIFIKASI LAYAR & KATALOG SENSOR HARDWARE"),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(
              color: PdfColors.grey300,
              width: 0.5,
            ),
            children: [
              _buildTableRow(
                  "Refresh Rate",
                  state.displaySpecs.refreshRateCategory,
                  "Resolusi Layar",
                  state.displaySpecs.resolutionString),
              _buildTableRow(
                  "Screen Density (DPI)",
                  state.displaySpecs.densityDpiString,
                  "Rasio Aspek Layar",
                  state.displaySpecs.aspectRatioString),
              _buildTableRow(
                  "Ukuran Diagonal Fisik",
                  state.displaySpecs.screenDiagonalInches,
                  "Pixel Ratio / Scale",
                  state.displaySpecs.scaleString),
              _buildTableRow(
                  "HDR Support",
                  state.displaySpecs.isHdr ? "HDR10 / Wide Gamut" : "SDR Display",
                  "Total Sensor Fisik",
                  "${state.sensorsCatalog.totalSensorsCount} Sensor Terpasang"),
            ],
          ),
          pw.SizedBox(height: 8),

          // Sensors Checklist Mini Table
          pw.Text("Katalog Sensor Utama Motherboard:",
              style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey700)),
          pw.SizedBox(height: 4),
          pw.Wrap(
            spacing: 6,
            runSpacing: 4,
            children: state.sensorsCatalog.checklist.map((s) {
              final isOk = s.isAvailable;
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: pw.BoxDecoration(
                  color: isOk ? PdfColors.green50 : PdfColors.grey100,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(3)),
                  border: pw.Border.all(
                      color: isOk ? PdfColors.green300 : PdfColors.grey300,
                      width: 0.5),
                ),
                child: pw.Text(
                  "${s.label}: ${isOk ? 'Tersedia' : 'Tidak Ada'}",
                  style: pw.TextStyle(
                    fontSize: 7.5,
                    color: isOk ? PdfColors.green900 : PdfColors.grey700,
                    fontWeight: isOk
                        ? pw.FontWeight.bold
                        : pw.FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
          pw.SizedBox(height: 14),

          // 4. Live Debug Audit Trail Logs
          _buildPdfSectionTitle("4. AUDIT TRAIL & LOG DEBUG SISTEM TERAKHIR"),
          pw.SizedBox(height: 6),
          if (logs.isEmpty)
            pw.Text("Tidak ada log tersimpan.",
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600))
          else
            pw.Column(
              children: logs.map((log) {
                final isErr = log.level == LogLevel.error;
                final isWarn = log.level == LogLevel.warn;
                final color = isErr
                    ? PdfColors.red800
                    : (isWarn ? PdfColors.orange800 : PdfColors.grey800);

                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2.5),
                  margin: const pw.EdgeInsets.only(bottom: 2),
                  decoration: pw.BoxDecoration(
                    color: isErr
                        ? PdfColors.red50
                        : (isWarn ? PdfColors.amber50 : PdfColors.grey50),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(2)),
                  ),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 55,
                        child: pw.Text(log.formattedTime,
                            style: const pw.TextStyle(
                                fontSize: 7, color: PdfColors.grey600)),
                      ),
                      pw.SizedBox(
                        width: 70,
                        child: pw.Text("[${log.tag}]",
                            style: pw.TextStyle(
                                fontSize: 7,
                                fontWeight: pw.FontWeight.bold,
                                color: color)),
                      ),
                      pw.Expanded(
                        child: pw.Text(log.message,
                            style: pw.TextStyle(fontSize: 7, color: color)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfHeader(DeviceDiagnosticsEvent event, String nowFormatted) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blue800, width: 1.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "LAPORAN DIAGNOSTIK & TELEMETRI PERANGKAT",
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.Text(
                "Laporan Otomatis Live Hardware & Security Audit",
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blue800,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
                ),
                child: pw.Text(
                  event.model,
                  style: pw.TextStyle(
                    fontSize: 8.5,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text("Waktu: $nowFormatted",
                  style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Project Clone • Device Diagnostics Engine v1.0",
              style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
          pw.Text("Halaman ${context.pageNumber} dari ${context.pagesCount}",
              style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  pw.Widget _buildPdfSectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: const pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.blue800, width: 3),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 9.5,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  pw.TableRow _buildTableRow(
      String label1, String value1, String label2, String value2) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label1,
                  style: const pw.TextStyle(
                      fontSize: 7.5, color: PdfColors.grey600)),
              pw.Text(value1,
                  style: pw.TextStyle(
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey900)),
            ],
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(label2,
                  style: const pw.TextStyle(
                      fontSize: 7.5, color: PdfColors.grey600)),
              pw.Text(value2,
                  style: pw.TextStyle(
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey900)),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a complete JSON report string containing all device diagnostic telemetry
  String generateJsonReport({
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) {
    final Map<String, dynamic> fullData = {
      "reportTitle": "Device Diagnostics Telemetry Snapshot",
      "generatedAt": DateTime.now().toUtc().toIso8601String(),
      "deviceIdentity": {
        "userId": event.userId,
        "deviceIdHash": event.deviceIdHash,
        "installationIdHash": event.installationIdHash,
        "model": event.model,
        "device": event.device,
        "brand": event.brand,
        "manufacturer": event.manufacturer,
        "appVersion": event.appVersion,
        "osVersion": state.osVersion,
        "osBuild": state.osBuild,
      },
      "securityAudit": {
        "isRooted": state.isRooted,
        "isDeveloperMode": state.isDeveloperMode,
        "isMockLocation": state.isMockLocation,
        "isEmulator": state.isEmulator,
        "hasBiometricHardware": state.hasBiometricHardware,
        "isBiometricEnrolled": state.isBiometricEnrolled,
        "isVpnActive": state.isVpnActive,
      },
      "hardwareTelemetry": {
        "battery": {
          "level": event.batteryLevel,
          "state": event.batteryState,
          "temperatureCelsius": event.temperatureCelsius,
          "health": event.batteryHealth,
          "technology": event.batteryTechnology,
          "voltageMv": event.batteryVoltageMv,
          "isPowerSaveMode": event.isPowerSaveMode,
        },
        "memoryAndStorage": {
          "ramAvailableBytes": event.ramAvailableBytes,
          "ramTotalBytes": event.totalRamBytes,
          "ramAvailableFormatted": event.formattedAvailableRam,
          "ramTotalFormatted": event.formattedTotalRam,
          "storageAvailableBytes": event.storageAvailableBytes,
          "storageTotalBytes": event.totalStorageBytes,
          "storageAvailableFormatted": event.formattedAvailableStorage,
          "storageTotalFormatted": event.formattedTotalStorage,
        },
      },
      "network": {
        "isOnline": state.networkInfo.isOnline,
        "connectionType": state.networkInfo.connectionLabel,
        "ipAddress": state.networkInfo.ipAddress,
        "latencyMs": state.networkInfo.latencyMs,
      },
      "displaySpecs": {
        "refreshRateHz": state.displaySpecs.refreshRate,
        "supportedRefreshRates": state.displaySpecs.supportedRefreshRates,
        "resolution": state.displaySpecs.resolutionString,
        "densityDpi": state.displaySpecs.densityDpi,
        "aspectRatio": state.displaySpecs.aspectRatioString,
        "screenDiagonalInches": state.displaySpecs.screenDiagonalInches,
        "isHdr": state.displaySpecs.isHdr,
      },
      "sensorsCatalog": {
        "totalCount": state.sensorsCatalog.totalSensorsCount,
        "availableCount": state.sensorsCatalog.availableSensorsCount,
        "sensors": state.sensorsCatalog.checklist
            .map((s) => {
                  "key": s.keyName,
                  "label": s.label,
                  "available": s.isAvailable,
                  "hardwareName": s.hardwareName,
                })
            .toList(),
      },
      "recentLogs": DiagnosticsLoggerService.instance.logs
          .take(20)
          .map((l) => {
                "time": l.formattedTime,
                "level": l.level.name,
                "tag": l.tag,
                "message": l.message,
              })
          .toList(),
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(fullData);
  }

  /// Builds a Markdown formatted text summary for sharing
  String generateMarkdownReport({
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) {
    final buffer = StringBuffer();
    buffer.writeln("📱 *DEVICE DIAGNOSTICS & TELEMETRY REPORT*");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("🗓️ *Waktu*: ${event.timestamp.toLocal().toString().split('.')[0]}");
    buffer.writeln("📱 *Perangkat*: ${event.brand} ${event.model} (${event.device})");
    buffer.writeln("🤖 *OS*: ${state.osVersion} • Build: ${state.osBuild}");
    buffer.writeln("📦 *App Version*: v${event.appVersion}");
    buffer.writeln("👤 *User ID*: ${event.userId}");
    buffer.writeln("");
    buffer.writeln("🛡️ *AUDIT KEAMANAN & FRAUD*");
    buffer.writeln("• Fake GPS: ${state.isMockLocation ? '🔴 AKTIF (MOCK)' : '🟢 Clean (Aman)'}");
    buffer.writeln("• Platform: ${state.isEmulator ? '🔴 Emulator/VM' : '🟢 Fisik Asli'}");
    buffer.writeln("• Biometrik: ${state.hasBiometricHardware ? (state.isBiometricEnrolled ? '🟢 Terdaftar' : '🟠 Belum Didaftar') : '⚪ Tidak Ada'}");
    buffer.writeln("• VPN / Proxy: ${state.isVpnActive ? '🟠 VPN Aktif' : '🟢 Direct Link'}");
    buffer.writeln("• Root Status: ${state.isRooted ? '🔴 Rooted' : '🟢 Not Rooted'}");
    buffer.writeln("• Developer Mode: ${state.isDeveloperMode ? '🟠 ON' : '🟢 OFF'}");
    buffer.writeln("");
    buffer.writeln("🔋 *BATERAI & HARDWARE*");
    buffer.writeln("• Level: ${event.batteryLevel}% (${event.batteryState})");
    buffer.writeln("• Suhu: ${event.formattedBatteryTemp} (${event.batteryTempStatus})");
    buffer.writeln("• Health & Tech: ${event.batteryHealthLabel} • ${event.batteryTechnology} (${event.formattedVoltage})");
    buffer.writeln("• Power Saver: ${event.powerSaveModeLabel}");
    buffer.writeln("• Sisa RAM: ${event.formattedAvailableRam} / ${event.formattedTotalRam}");
    buffer.writeln("• Sisa Storage: ${event.formattedAvailableStorage} / ${event.formattedTotalStorage}");
    buffer.writeln("");
    buffer.writeln("🌐 *JARINGAN & LAYAR*");
    buffer.writeln("• Status: ${state.networkInfo.isOnline ? '🟢 Online (${state.networkInfo.latencyMs} ms)' : '🔴 Offline'} (${state.networkInfo.connectionLabel})");
    buffer.writeln("• IP: ${state.networkInfo.ipAddress}");
    buffer.writeln("• Layar: ${state.displaySpecs.refreshRateCategory} • ${state.displaySpecs.resolutionString} (${state.displaySpecs.densityDpiString})");
    buffer.writeln("• Sensor: ${state.sensorsCatalog.availableSensorsCount}/8 Sensor Utama Terdeteksi");
    buffer.writeln("");
    buffer.writeln("🔑 *DEVICE ID SHA-256 HASH*");
    buffer.writeln("`${event.deviceIdHash}`");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln("_Generated automatically by Project Clone Diagnostics_");

    return buffer.toString();
  }

  /// Opens native print preview / share sheet for PDF report
  Future<void> sharePdfReport({
    required BuildContext context,
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) async {
    try {
      final pdfBytes = await generatePdfReport(event: event, state: state);
      final filename =
          "Diagnostics_Report_${event.model.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf";

      await Printing.sharePdf(bytes: pdfBytes, filename: filename);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membagikan PDF: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// Opens direct PDF print / layout preview modal
  Future<void> previewOrPrintPdf({
    required BuildContext context,
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) async {
    try {
      await Printing.layoutPdf(
        name: "Diagnostics_Report_${event.model}",
        onLayout: (format) async =>
            await generatePdfReport(event: event, state: state),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membuka preview PDF: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  /// Copies any text or JSON report to clipboard
  Future<void> copyToClipboard(
    BuildContext context,
    String text, {
    String label = "Laporan Diagnostik",
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.greenAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$label berhasil disalin ke clipboard!",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  /// Shares summary report directly to WhatsApp
  Future<void> shareToWhatsApp({
    required BuildContext context,
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) async {
    final text = generateMarkdownReport(event: event, state: state);
    final encoded = Uri.encodeComponent(text);
    final uri = Uri.parse("https://wa.me/?text=$encoded");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await copyToClipboard(context, text, label: "Laporan WhatsApp");
      }
    } catch (_) {
      if (context.mounted) {
        await copyToClipboard(context, text, label: "Laporan WhatsApp");
      }
    }
  }

  /// Opens email composer with diagnostic report
  Future<void> shareToEmail({
    required BuildContext context,
    required DeviceDiagnosticsEvent event,
    required DiagnosticsBlocState state,
  }) async {
    final subject = Uri.encodeComponent(
        "Device Diagnostics Report - ${event.brand} ${event.model} (ID: ${event.deviceIdHash.substring(0, 8)})");
    final body =
        Uri.encodeComponent(generateMarkdownReport(event: event, state: state));
    final uri = Uri.parse("mailto:?subject=$subject&body=$body");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await copyToClipboard(context, generateMarkdownReport(event: event, state: state),
            label: "Laporan Email");
      }
    } catch (_) {
      if (context.mounted) {
        await copyToClipboard(context, generateMarkdownReport(event: event, state: state),
            label: "Laporan Email");
      }
    }
  }
}
