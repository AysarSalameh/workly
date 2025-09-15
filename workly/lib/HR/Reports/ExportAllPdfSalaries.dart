import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' show PdfGoogleFonts;

// conditional import
import 'export_pdf_stub.dart'
if (dart.library.html) 'export_pdf_web.dart';

class ExportAllPdfSalaries extends StatelessWidget {
  final List<Employee> employees;
  final List<dynamic> salaries;
  final String companyName;
  final String companyLogoUrl;

  const ExportAllPdfSalaries({
    super.key,
    required this.employees,
    required this.salaries,
    required this.companyName,
    required this.companyLogoUrl,
  });

  Future<void> generatePdf(BuildContext context) async {
    if (!kIsWeb) {
      _showSnackBar(context, 'هذه الخاصية تعمل على Web فقط!', isError: true);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdf = pw.Document();
      final ttf = await PdfGoogleFonts.cairoRegular();
      final ttfBold = await PdfGoogleFonts.cairoBold();
      final ttfLight = await PdfGoogleFonts.cairoLight();
      final logoBytes = await _loadCompanyLogo();

      // فهرس للموظفين إذا كانوا أكثر من 5
      if (salaries.length > 5) {
        pdf.addPage(_buildIndexPage(ttf, ttfBold, logoBytes));
      }

      // صفحات الرواتب
      for (int i = 0; i < salaries.length; i++) {
        final empSalary = salaries[i];
        final employee = _findEmployeeByEmail(empSalary.email);

        pdf.addPage(_buildSalaryPage(
          employee: employee,
          empSalary: empSalary,
          ttf: ttf,
          ttfBold: ttfBold,
          ttfLight: ttfLight,
          logoBytes: logoBytes,
          pageNumber: i + 1,
          totalPages: salaries.length,
        ));
      }

      final bytes = await pdf.save();
      Navigator.of(context).pop(); // إغلاق مؤشر التحميل

      downloadPdfWeb(bytes, "All-Salaries-${_getCurrentDateString()}.pdf");
      _showSnackBar(context, 'تم تصدير ${salaries.length} راتب بنجاح!');
    } catch (e) {
      Navigator.of(context).pop();
      _showSnackBar(context, 'خطأ في تصدير PDF: ${e.toString()}', isError: true);
    }
  }

  Future<Uint8List?> _loadCompanyLogo() async {
    try {
      if (companyLogoUrl.isEmpty) return null;
      final response = await http.get(Uri.parse(companyLogoUrl));
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint('خطأ في تحميل اللوجو: $e');
    }
    return null;
  }

  Employee _findEmployeeByEmail(String email) {
    return employees.firstWhere(
          (e) => e.email == email,
      orElse: () => Employee(
        id: 'غير محدد',
        name: 'موظف غير مسجل',
        email: email,
        phoneNumber: 'غير محدد',
        iban: 'غير محدد',
        address: 'غير محدد',
        birthDate: 'غير محدد',
        hrStatus: 'غير محدد',
        profileImage: '',
        companyCode: '',
        companyLat: 0,
        companyLng: 0,
        createdAt: Timestamp.now(),
        idImage: '',
        ratePerHour: 0,
      ),
    );
  }

  // ========================= PDF Pages =========================
  pw.Page _buildIndexPage(pw.Font ttf, pw.Font ttfBold, Uint8List? logoBytes) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            _buildHeader(ttfBold, logoBytes),
            pw.SizedBox(height: 30),
            pw.Text('فهرس الرواتب', style: pw.TextStyle(font: ttfBold, fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildTableCell('م', ttfBold, isHeader: true),
                    _buildTableCell('اسم الموظف', ttfBold, isHeader: true),
                    _buildTableCell('الراتب', ttfBold, isHeader: true),
                    _buildTableCell('الصفحة', ttfBold, isHeader: true),
                  ],
                ),
                ...salaries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final empSalary = entry.value;
                  final employee = _findEmployeeByEmail(empSalary.email);
                  return pw.TableRow(
                    children: [
                      _buildTableCell('${index + 1}', ttf),
                      _buildTableCell(employee.name, ttf),
                      _buildTableCell('${empSalary.salary.toStringAsFixed(2)} ر.س', ttf),
                      _buildTableCell('${index + 2}', ttf),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Page _buildSalaryPage({
    required Employee employee,
    required dynamic empSalary,
    required pw.Font ttf,
    required pw.Font ttfBold,
    required pw.Font ttfLight,
    required Uint8List? logoBytes,
    required int pageNumber,
    required int totalPages,
  }) {
    String releaseDateStr = _formatReleaseDate(empSalary.releaseDate);

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (_) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(ttfBold, logoBytes),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: pw.BoxDecoration(color: PdfColors.blue50),
                child: pw.Text(
                  'كشف راتب',
                  style: pw.TextStyle(font: ttfBold, fontSize: 20, color: PdfColors.blue800),
                ),
              ),
            ),
            pw.SizedBox(height: 25),
            _buildEmployeeInfoSection(employee, ttf, ttfBold),
            pw.SizedBox(height: 20),
            _buildSalaryInfoSection(empSalary, releaseDateStr, ttf, ttfBold),
            _buildAdditionalDetails(empSalary, ttf, ttfLight),
            pw.Spacer(),
            _buildFooter(ttf, ttfLight, pageNumber, totalPages),
          ],
        ),
      ),
    );
  }

  // ========================= PDF Helpers =========================
  pw.Widget _buildHeader(pw.Font ttfBold, Uint8List? logoBytes) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(companyName, style: pw.TextStyle(font: ttfBold, fontSize: 18, color: PdfColors.blue800)),
            pw.SizedBox(height: 5),
            pw.Text('تاريخ الإصدار: ${_getCurrentDateString()}', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColors.grey600)),
          ],
        ),
        if (logoBytes != null)
          pw.Image(pw.MemoryImage(logoBytes), width: 70, height: 70),
      ],
    );
  }

  pw.Widget _buildEmployeeInfoSection(Employee employee, pw.Font ttf, pw.Font ttfBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('بيانات الموظف', style: pw.TextStyle(font: ttfBold, fontSize: 16, color: PdfColors.blue800)),
          pw.SizedBox(height: 10),
          _buildInfoRow('اسم الموظف:', employee.name, ttf, ttfBold),
          _buildInfoRow('البريد الإلكتروني:', employee.email, ttf, ttfBold),
          _buildInfoRow('رقم الهوية:', employee.id, ttf, ttfBold),
          _buildInfoRow('رقم الهاتف:', employee.phoneNumber.isNotEmpty ? employee.phoneNumber : 'غير محدد', ttf, ttfBold),
          _buildInfoRow('رقم الآيبان:', employee.iban.isNotEmpty ? employee.iban : 'غير محدد', ttf, ttfBold),
        ],
      ),
    );
  }

  pw.Widget _buildSalaryInfoSection(dynamic empSalary, String releaseDateStr, pw.Font ttf, pw.Font ttfBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('تفاصيل الراتب', style: pw.TextStyle(font: ttfBold, fontSize: 16, color: PdfColors.green800)),
          pw.SizedBox(height: 10),
          _buildInfoRow('عدد الساعات المحسوبة:', '${empSalary.totalMonthHours} ساعة', ttf, ttfBold),
          _buildInfoRow('أجر الساعة الواحدة:', '${empSalary.ratePerHour.toStringAsFixed(2)} ر.س', ttf, ttfBold),
          _buildInfoRow('إجمالي الراتب:', '${empSalary.salary.toStringAsFixed(2)} ر.س', ttf, ttfBold),
          _buildInfoRow('تاريخ الإصدار:', releaseDateStr, ttf, ttfBold),
        ],
      ),
    );
  }

  pw.Widget _buildAdditionalDetails(dynamic empSalary, pw.Font ttf, pw.Font ttfLight) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue200),
      ),
      child: pw.Text(
        '• هذا الكشف صالح للاستخدام الرسمي\n• تم إنتاجه آلياً من النظام\n• للاستفسارات يرجى التواصل مع قسم الموارد البشرية',
        style: pw.TextStyle(font: ttfLight, fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  pw.Widget _buildFooter(pw.Font ttf, pw.Font ttfLight, int pageNumber, int totalPages) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('تم الإنتاج في: ${_getCurrentDateString()}', style: pw.TextStyle(font: ttfLight, fontSize: 9, color: PdfColors.grey500)),
            pw.Text('صفحة $pageNumber من $totalPages', style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value, pw.Font ttf, pw.Font ttfBold) {
    return pw.Row(
      children: [
        pw.Expanded(flex: 2, child: pw.Text(label, style: pw.TextStyle(font: ttfBold, fontSize: 12))),
        pw.Expanded(flex: 3, child: pw.Text(value, style: pw.TextStyle(font: ttf, fontSize: 12))),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: isHeader ? 12 : 10, color: isHeader ? PdfColors.blue800 : PdfColors.black),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  String _formatReleaseDate(dynamic releaseDate) {
    if (releaseDate == null) return 'غير محدد';
    try {
      DateTime date;
      if (releaseDate is Timestamp) date = releaseDate.toDate();
      else if (releaseDate is DateTime) date = releaseDate;
      else return 'غير محدد';
      return DateFormat('yyyy/MM/dd - EEEE', 'ar').format(date);
    } catch (_) {
      return 'تاريخ غير صحيح';
    }
  }

  String _getCurrentDateString() => DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now());

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ========================= UI Button =========================
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => generatePdf(context),
      icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 24),
      label: Text(
        "تصدير كل الرواتب PDF (${salaries.length})",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
      ),
    );
  }
}
