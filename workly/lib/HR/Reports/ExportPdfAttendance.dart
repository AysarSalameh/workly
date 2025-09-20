import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' show PdfGoogleFonts;

// conditional import
import 'export_pdf_stub.dart'
if (dart.library.html) 'export_pdf_web.dart';

class ExportPdfAttendance extends StatelessWidget {
  final String empName;
  final String empEmail;
  final String hrName;
  final String companyName;
  final String companyLogoUrl;
  final List<Map<String, dynamic>> attendance;
  final int month;
  final int year;

  const ExportPdfAttendance({
    super.key,
    required this.empName,
    required this.empEmail,
    required this.hrName,
    required this.companyName,
    required this.companyLogoUrl,
    required this.attendance,
    required this.month,
    required this.year,
  });

  String formatHours(num? total, bool isArabic) {
    if (total == null) return isArabic ? "غير متوفر" : "N/A";
    final totalMinutes = (total * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (isArabic) {
      if (minutes == 0) return "$hours ساعة";
      return "$hours ساعة $minutes دقيقة";
    } else {
      if (minutes == 0) return "$hours h";
      return "$hours h $minutes m";
    }
  }

  Future<void> generatePdf(BuildContext context) async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذه الخاصية تعمل على Web فقط!'),
        ),
      );
      return;
    }

    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final pdf = pw.Document();
    final ttf = await PdfGoogleFonts.cairoRegular();
    final ttfBold = await PdfGoogleFonts.cairoBold();

    // تحميل صورة الشركة من الإنترنت
    final response = await http.get(Uri.parse(companyLogoUrl));
    final netImage = pw.MemoryImage(response.bodyBytes);

    // حساب أيام الشهر
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int presentDays = attendance.where((day) => day['checkIn'] != null).length;
    int absentDays = daysInMonth - presentDays;
    double totalHours = attendance.fold(
      0.0,
          (sum, day) => sum + ((day['totalHours'] ?? 0) as num).toDouble(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Directionality(
            textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
            child: pw.Column(
              crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
              children: [
                // Header: شعار الشركة والبيانات
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(companyName, style: pw.TextStyle(font: ttfBold, fontSize: 18)),
                        pw.SizedBox(height: 4),
                        pw.Text("${loc.hrName}: $hrName", style: pw.TextStyle(font: ttf)),
                      ],
                    ),
                    pw.Container(width: 60, height: 60, child: pw.Image(netImage, fit: pw.BoxFit.contain)),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Column(
                  crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("${loc.employeeName}: $empName", style: pw.TextStyle(font: ttfBold)),
                    pw.SizedBox(height: 4),
                    pw.Text("${loc.email}: $empEmail", style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Summary Box
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      summaryBox(ttf, ttfBold, loc.daysPresent, presentDays.toString(), isArabic),
                      summaryBox(ttf, ttfBold, loc.daysAbsent, absentDays.toString(), isArabic, color: PdfColors.red100),
                      summaryBox(ttf, ttfBold, loc.totalHours, formatHours(totalHours, isArabic), isArabic, color: PdfColors.blue100),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),

                // Attendance Table
                pw.Table.fromTextArray(
                  headers: [loc.date, loc.checkIn, loc.checkOut, loc.totalHours],
                  data: attendance.map((day) {
                    final checkIn = day['checkIn'] != null
                        ? DateFormat('MMM dd, yyyy – HH:mm').format(day['checkIn'].toDate())
                        : loc.notAvailable;
                    final checkOut = day['checkOut'] != null
                        ? DateFormat('MMM dd, yyyy – HH:mm').format(day['checkOut'].toDate())
                        : loc.notAvailable;
                    final totalHrs = day['totalHours'] != null
                        ? formatHours(day['totalHours'], isArabic)
                        : loc.notAvailable;
                    return [
                      DateFormat.yMd().format(day['date'].toDate()),
                      checkIn,
                      checkOut,
                      totalHrs,
                    ];
                  }).toList(),
                  headerStyle: pw.TextStyle(font: ttfBold, fontSize: 12),
                  cellStyle: pw.TextStyle(font: ttf, fontSize: 10),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  cellAlignment: isArabic ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FlexColumnWidth(3),
                    3: pw.FlexColumnWidth(2),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    downloadPdfWeb(bytes, "$empName-Attendance.pdf");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => generatePdf(context),
      icon: const Icon(Icons.picture_as_pdf),
      label: Text(AppLocalizations.of(context)!.exportPdf),
    );
  }
}

// دالة ملخص الحضور
pw.Container summaryBox(
    pw.Font ttf, pw.Font ttfBold, String title, String value, bool isArabic,
    {PdfColor color = PdfColors.green100}
    ) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: pw.BoxDecoration(
      color: color,
      borderRadius: pw.BorderRadius.circular(4),
    ),
    child: pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(font: ttfBold)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(font: ttf)),
      ],
    ),
  );
}
