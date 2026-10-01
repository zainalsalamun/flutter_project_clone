import 'package:flutter/material.dart';

class FamilyMember {
  final String name;
  final String relation; // Kepala Keluarga, Istri, Anak
  final String nik;
  final String age;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.nik,
    required this.age,
  });
}

class WargaUserProfile {
  final String name;
  final String fullName;
  final String role;
  final String blockNumber;
  final String rtRw;
  final String village;
  final String nik;
  final String kkNumber;
  final String phone;
  final String avatarUrl;
  final String duesStatus;
  final bool isDuesPaidCurrentMonth;
  final List<FamilyMember> familyMembers;

  const WargaUserProfile({
    required this.name,
    required this.fullName,
    required this.role,
    required this.blockNumber,
    required this.rtRw,
    required this.village,
    required this.nik,
    required this.kkNumber,
    required this.phone,
    required this.avatarUrl,
    required this.duesStatus,
    this.isDuesPaidCurrentMonth = true,
    this.familyMembers = const [],
  });
}

class KasSummary {
  final double totalKas;
  final double monthlyIncome;
  final double monthlyExpense;
  final String lastAuditDate;
  final String bankName;
  final String accountNumber;
  final String accountHolder;

  const KasSummary({
    required this.totalKas,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.lastAuditDate,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
  });
}

enum KasCategory {
  iuranWarga,
  satpamKeamanan,
  sampahKebersihan,
  perbaikanFasilitas,
  kegiatanSosial,
  operasionalRT,
}

class KasTransaction {
  final String id;
  final String title;
  final KasCategory category;
  final double amount;
  final bool isIncome;
  final String date;
  final String receiptNumber;
  final String notes;
  final String verifiedBy;

  const KasTransaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.receiptNumber,
    required this.notes,
    required this.verifiedBy,
  });
}

class IuranPeriod {
  final String id;
  final String month;
  final int year;
  final double amountKasRT;
  final double amountSatpam;
  final double amountKebersihan;
  bool isPaid;
  final String? paidAt;
  final String? paymentMethod;
  final String? receiptRef;

  IuranPeriod({
    required this.id,
    required this.month,
    required this.year,
    this.amountKasRT = 50000,
    this.amountSatpam = 60000,
    this.amountKebersihan = 40000,
    required this.isPaid,
    this.paidAt,
    this.paymentMethod,
    this.receiptRef,
  });

  double get totalAmount => amountKasRT + amountSatpam + amountKebersihan;
}

class AgendaItem {
  final String id;
  final String categoryBadge;
  final Color categoryBadgeColor;
  final String organizer;
  final String timeAgo;
  final String title;
  final String description;
  final String dateFormatted;
  final String timeFormatted;
  final String location;
  int attendeeCount;
  final List<String> attendeeInitials;
  bool isConfirmed;
  final String actionLabel;
  final bool isSiskamling;
  final String? shiftDetails;

  AgendaItem({
    required this.id,
    required this.categoryBadge,
    required this.categoryBadgeColor,
    required this.organizer,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.dateFormatted,
    required this.timeFormatted,
    required this.location,
    required this.attendeeCount,
    this.attendeeInitials = const ['H', 'R', 'A'],
    this.isConfirmed = false,
    this.actionLabel = 'Ikut Serta',
    this.isSiskamling = false,
    this.shiftDetails,
  });
}

class AnnouncementItem {
  final String id;
  final String badge;
  final Color badgeColor;
  final String title;
  final String snippet;
  final String fullContent;
  final String publisher;
  final String date;
  bool isUnread;

  AnnouncementItem({
    required this.id,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.snippet,
    required this.fullContent,
    required this.publisher,
    required this.date,
    this.isUnread = false,
  });
}

enum SuratStatus {
  menunggu,
  disetujui,
  selesai,
}

class SuratPengantarRequest {
  final String id;
  final String requestNumber;
  final String letterType;
  final String purpose;
  final String applicantName;
  final String applicantNik;
  final String blockNumber;
  final SuratStatus status;
  final String qrCodeHash;
  final String createdDate;
  final String signedByRt;

  const SuratPengantarRequest({
    required this.id,
    required this.requestNumber,
    required this.letterType,
    required this.purpose,
    required this.applicantName,
    required this.applicantNik,
    required this.blockNumber,
    required this.status,
    required this.qrCodeHash,
    required this.createdDate,
    required this.signedByRt,
  });
}

enum ComplaintStatus {
  diajukan,
  diproses,
  selesai,
}

class ComplaintReport {
  final String id;
  final String ticketNumber;
  final String category;
  final IconData categoryIcon;
  final String title;
  final String description;
  final String locationAddress;
  final String? photoUrl;
  ComplaintStatus status;
  final String reportedDate;
  final String? rtNotes;

  ComplaintReport({
    required this.id,
    required this.ticketNumber,
    required this.category,
    required this.categoryIcon,
    required this.title,
    required this.description,
    required this.locationAddress,
    this.photoUrl,
    required this.status,
    required this.reportedDate,
    this.rtNotes,
  });
}

class ResidentContact {
  final String id;
  final String name;
  final String block;
  final String houseNumber;
  final String phone;
  final String role; // e.g. "Kepala Keluarga", "Ketua RT", "Sekretaris", "Warga"
  final bool isVerified;
  final String avatarUrl;

  const ResidentContact({
    required this.id,
    required this.name,
    required this.block,
    required this.houseNumber,
    required this.phone,
    required this.role,
    this.isVerified = true,
    required this.avatarUrl,
  });
}
