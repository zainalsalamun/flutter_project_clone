import 'package:flutter/material.dart';
import '../bloc/diagnostics_bloc_state.dart';
import '../models/device_diagnostics_event.dart';
import '../services/diagnostics_report_service.dart';
import '../theme/diagnostics_colors.dart';

class ExportAndShareCard extends StatelessWidget {
  final DeviceDiagnosticsEvent event;
  final DiagnosticsBlocState state;

  const ExportAndShareCard({
    super.key,
    required this.event,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final reportService = DiagnosticsReportService.instance;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DiagnosticsColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DiagnosticsColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(Icons.ios_share_rounded,
                        size: 18, color: DiagnosticsColors.primary),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "EXPORT & SHARE DIAGNOSTICS",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: DiagnosticsColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: DiagnosticsColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "PDF • JSON • SHARE",
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: DiagnosticsColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Cetak dan bagikan berkas bukti diagnostik audit sistem dalam format PDF, JSON murni, atau teks WhatsApp.",
            style: TextStyle(
              fontSize: 10.5,
              color: DiagnosticsColors.textSubtle,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // Primary Row of Main Export Actions (PDF and JSON)
          Row(
            children: [
              // PDF Export Button
              Expanded(
                child: InkWell(
                  onTap: () => _showPdfOptions(context, reportService),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [DiagnosticsColors.dangerDark, Color(0xFFB91C1C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: DiagnosticsColors.dangerDark.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf_rounded,
                            color: DiagnosticsColors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          "Export PDF Report",
                          style: TextStyle(
                            color: DiagnosticsColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // JSON Export Button
              Expanded(
                child: InkWell(
                  onTap: () => _showJsonModal(context, reportService),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: DiagnosticsColors.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: DiagnosticsColors.darkSurface.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.code_rounded,
                            color: DiagnosticsColors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          "Export Raw JSON",
                          style: TextStyle(
                            color: DiagnosticsColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Secondary Row of Share Actions (Clipboard, WhatsApp, Email)
          Row(
            children: [
              // Copy to Clipboard Button
              Expanded(
                child: _ShareActionButton(
                  icon: Icons.copy_all_rounded,
                  label: "Copy Summary",
                  pair: DiagnosticsStatusPair.primary,
                  onTap: () {
                    final text = reportService.generateMarkdownReport(
                        event: event, state: state);
                    reportService.copyToClipboard(context, text,
                        label: "Ringkasan Diagnostik");
                  },
                ),
              ),
              const SizedBox(width: 6),

              // WhatsApp Share Button
              Expanded(
                child: _ShareActionButton(
                  icon: Icons.chat_rounded,
                  label: "WhatsApp",
                  pair: DiagnosticsStatusPair.success,
                  onTap: () => reportService.shareToWhatsApp(
                    context: context,
                    event: event,
                    state: state,
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Email Share Button
              Expanded(
                child: _ShareActionButton(
                  icon: Icons.mail_outline_rounded,
                  label: "Email Report",
                  pair: DiagnosticsStatusPair.info,
                  onTap: () => reportService.shareToEmail(
                    context: context,
                    event: event,
                    state: state,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPdfOptions(
      BuildContext context, DiagnosticsReportService reportService) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DiagnosticsColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded,
                            color: DiagnosticsColors.dangerDark, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Pilihan Laporan PDF",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: DiagnosticsColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dokumen PDF mencakup seluruh riwayat telemetri, identitas hardware, audit keamanan, dan log debug sistem.",
                  style: TextStyle(fontSize: 11, color: DiagnosticsColors.textSubtle),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DiagnosticsColors.dangerDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.print_rounded,
                        color: DiagnosticsColors.dangerDark, size: 20),
                  ),
                  title: const Text("Print / Preview PDF",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text(
                      "Buka halaman pratinjau dokumen dan cetak langsung",
                      style: TextStyle(fontSize: 10.5)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: DiagnosticsColors.textMuted),
                  onTap: () {
                    Navigator.pop(ctx);
                    reportService.previewOrPrintPdf(
                      context: context,
                      event: event,
                      state: state,
                    );
                  },
                ),
                const Divider(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DiagnosticsColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.share_rounded,
                        color: DiagnosticsColors.primary, size: 20),
                  ),
                  title: const Text("Bagikan File PDF (Share Sheet)",
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text(
                      "Kirim file .pdf via AirDrop, Bluetooth, Telegram, Drive, dll",
                      style: TextStyle(fontSize: 10.5)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: DiagnosticsColors.textMuted),
                  onTap: () {
                    Navigator.pop(ctx);
                    reportService.sharePdfReport(
                      context: context,
                      event: event,
                      state: state,
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showJsonModal(
      BuildContext context, DiagnosticsReportService reportService) {
    final jsonStr =
        reportService.generateJsonReport(event: event, state: state);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DiagnosticsColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                       horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.code_rounded,
                              color: DiagnosticsColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Raw Telemetry JSON Payload",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: DiagnosticsColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DiagnosticsColors.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: SelectableText(
                        jsonStr,
                        style: const TextStyle(
                          color: DiagnosticsColors.primaryLight,
                          fontSize: 10,
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DiagnosticsColors.primary,
                          foregroundColor: DiagnosticsColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.copy_rounded, size: 16),
                        label: const Text("Salin Seluruh JSON ke Clipboard"),
                        onPressed: () {
                          reportService.copyToClipboard(context, jsonStr,
                              label: "Payload JSON");
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ShareActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final DiagnosticsStatusPair pair;
  final VoidCallback onTap;

  const _ShareActionButton({
    required this.icon,
    required this.label,
    required this.pair,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: pair.bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: pair.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: pair.textColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: pair.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
