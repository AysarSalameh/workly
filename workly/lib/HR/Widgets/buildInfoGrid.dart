import 'package:flutter/material.dart';// استدعاء ملف الترجمات
import 'package:projects_flutter/HR/Widgets/EmployeeLocationRow.dart';
import 'package:projects_flutter/HR/Widgets/buildInfoRow.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildInfoGrid(BuildContext context, Employee emp) {
  final loc = AppLocalizations.of(context)!; // 🔹 تعريف loc

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.employeeInformation, // 🔹 قابل للترجمة
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            buildInfoRow(loc.idNumber, emp.id, Icons.badge_outlined),
            buildInfoRow(loc.email, emp.email, Icons.email_outlined),
            buildInfoRow(loc.phoneNumber, emp.phoneNumber, Icons.phone_outlined),
            buildInfoRow(loc.iban, emp.iban, Icons.account_balance_outlined),
            buildInfoRow(loc.address, emp.address, Icons.location_on_outlined),
            buildInfoRow(loc.birthDate, emp.birthDate, Icons.cake_outlined),
            buildInfoRow(loc.companyCode, emp.companyCode, Icons.business_outlined),
            // buildInfoRow(
            //   loc.location,
            //   "Lat: ${emp.companyLat}, Lng: ${emp.companyLat}",
            //   Icons.map_outlined,
            // ),
            EmployeeLocationRow(lat: emp.companyLat, lng: emp.companyLng),
            // زر عرض الهوية إذا موجودة
            if (emp.idImage != null && emp.idImage!.isNotEmpty)
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    insetPadding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                emp.idImage!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(emp.idImage!);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              icon: const Icon(Icons.download),
                              label: Text(loc.downloadId), // 🔹 قابل للترجمة
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          loc.viewId, // 🔹 قابل للترجمة
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.open_in_new, color: Colors.blueAccent),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
