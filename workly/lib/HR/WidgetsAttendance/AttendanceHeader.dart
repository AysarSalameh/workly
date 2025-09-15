import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/screen/AttendancePage.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AttendanceHeader extends StatefulWidget {
  final String searchQuery;
  final FilterStatus filterStatus;
  final void Function(String) onSearchChanged;
  final void Function(FilterStatus) onFilterChanged;
  final AppLocalizations loc;

  const AttendanceHeader({
    super.key,
    required this.searchQuery,
    required this.filterStatus,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.loc,
  });

  @override
  State<AttendanceHeader> createState() => _AttendanceHeaderState();
}

class _AttendanceHeaderState extends State<AttendanceHeader> {
  late FilterStatus _selectedFilter;
  late String _searchQuery;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.filterStatus;
    _searchQuery = widget.searchQuery;
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = [
      {'label': widget.loc.all, 'value': FilterStatus.all},
      {'label': widget.loc.present, 'value': FilterStatus.present},
      {'label': widget.loc.absent, 'value': FilterStatus.absent},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade600, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.loc.attendancetracker,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    Text(
                        DateTime.now().toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Search + Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                        widget.onSearchChanged(value);
                      },
                      decoration: InputDecoration(
                        hintText: widget.loc.searchEmployees,
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.white.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FilterStatus>(
                      value: _selectedFilter,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white),
                      dropdownColor: Colors.indigo.shade700,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedFilter = value);
                          widget.onFilterChanged(value);
                        }
                      },
                      items: filterOptions.map((f) {
                        return DropdownMenuItem<FilterStatus>(
                          value: f['value'] as FilterStatus,
                          child: Text(f['label'] as String),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
