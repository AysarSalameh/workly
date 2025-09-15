// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
// import 'package:projects_flutter/l10n/app_localizations.dart';
// import 'package:http/http.dart' as http;
// import 'package:pdf/widgets.dart' show PdfGoogleFonts;
//
// // conditional import
// import 'export_pdf_stub.dart'
// if (dart.library.html) 'export_pdf_web.dart';
//
// class ExportPdfSalar extends StatelessWidget {
//   final Employee employee;
//   final dynamic empSalary; // يحتوي salary, totalMonthHours, ratePerHour, releaseDate
//   final String companyName;
//   final String companyLogoUrl;
//
//   const ExportPdfSalary({
//     super.key,
//     required this.employee,
//     required this.empSalary,
//     required this.companyName,
//     required this.companyLogoUrl,
//   });
//
//   Future<void> generatePdf(BuildContext context) async {
//     if (!kIsWeb) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('هذه الخاصية تعمل على Web فقط!')),
//       );
//       return;
//     }
//
//     final loc = AppLocalizations.of(context)!;
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';
//
//     final pdf = pw.Document();
//     final ttf = await PdfGoogleFonts.cairoRegular();
//     final ttfBold = await PdfGoogleFonts.cairoBold();
//
//     Uint8List? logoBytes;
//     try {
//       final response = await http.get(Uri.parse(companyLogoUrl));
//       if (response.statusCode == 200) logoBytes = response.bodyBytes;
//     } catch (_) {}
//
//     String releaseDateStr = '---';
//     if (empSalary.releaseDate != null) {
//       if (empSalary.releaseDate is Timestamp) {
//         releaseDateStr = DateFormat('yyyy-MM-dd')
//             .format((empSalary.releaseDate as Timestamp).toDate());
//       } else if (empSalary.releaseDate is DateTime) {
//         releaseDateStr = DateFormat('yyyy-MM-dd')
//             .format(empSalary.releaseDate as DateTime);
//       }
//     }
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => pw.Directionality(
//           textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
//           child: pw.Column(
//             crossAxisAlignment: isArabic
//                 ? pw.CrossAxisAlignment.end
//                 : pw.CrossAxisAlignment.start,
//             children: [
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text(companyName,
//                       style: pw.TextStyle(font: ttfBold, fontSize: 18)),
//                   if (logoBytes != null)
//                     pw.Image(pw.MemoryImage(logoBytes), width: 60, height: 60),
//                 ],
//               ),
//               pw.SizedBox(height: 16),
//
//               pw.Text("${loc.employeeName}: ${employee.name}",
//                   style: pw.TextStyle(font: ttfBold)),
//               pw.Text("${loc.email}: ${employee.email}",
//                   style: pw.TextStyle(font: ttf)),
//               pw.Text("رقم الهوية: ${employee.id}",
//                   style: pw.TextStyle(font: ttf)),
//               pw.Text("IBAN: ${employee.iban}", style: pw.TextStyle(font: ttf)),
//               pw.SizedBox(height: 16),
//
//               pw.Container(
//                 padding: const pw.EdgeInsets.all(8),
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all(color: PdfColors.grey),
//                   borderRadius: pw.BorderRadius.circular(8),
//                 ),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text("الساعات: ${empSalary.totalMonthHours}",
//                         style: pw.TextStyle(font: ttf)),
//                     pw.Text("الأجر بالساعة: ${empSalary.ratePerHour}",
//                         style: pw.TextStyle(font: ttf)),
//                     pw.Text(
//                         "الراتب الإجمالي: ${empSalary.salary.toStringAsFixed(2)}",
//                         style: pw.TextStyle(font: ttfBold)),
//                     pw.Text("تاريخ الإصدار: $releaseDateStr",
//                         style: pw.TextStyle(font: ttf)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     final bytes = await pdf.save();
//     downloadPdfWeb(bytes, "${employee.name}-Salary.pdf");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () => generatePdf(context),
//       icon: const Icon(Icons.picture_as_pdf),
//       label: Text(AppLocalizations.of(context)!.exportPdf),
//     );
//   }
// }
