import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AttendanceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  final String Function(DateTime) formatDate;
  final String Function(DateTime) formatTime;
  final String Function(double) formatDuration;
  final String Function(int) dayName;
  final Future<String> Function(double, double) getAddress;

  const AttendanceCard({
    required this.data,
    required this.index,
    required this.formatDate,
    required this.formatTime,
    required this.formatDuration,
    required this.dayName,
    required this.getAddress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Color(0xFF1E1E2C) : Colors.white;
    final titleColor = isDark ? Colors.white : Color(0xFF2D3748);
    final subTitleColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    final checkInTs = data['checkIn'] as Timestamp?;
    final checkInDate = checkInTs?.toDate() ?? DateTime.now();
    final checkOutDate = (data['checkOut'] as Timestamp?)?.toDate();
    final totalHours = (data['totalHours'] is num)
        ? (data['totalHours'] as num).toDouble()
        : 0.0;

    final checkInLat = (data['checkInLat'] is num)
        ? (data['checkInLat'] as num).toDouble()
        : null;
    final checkInLng = (data['checkInLng'] is num)
        ? (data['checkInLng'] as num).toDouble()
        : null;
    final checkOutLat = (data['checkOutLat'] is num)
        ? (data['checkOutLat'] as num).toDouble()
        : null;
    final checkOutLng = (data['checkOutLng'] is num)
        ? (data['checkOutLng'] as num).toDouble()
        : null;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showDetailDialog(
                  context,
                  checkInDate,
                  checkOutDate,
                  totalHours,
                  checkInLat,
                  checkInLng,
                  checkOutLat,
                  checkOutLng,
                  loc,
                  isDark,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isDark
                                        ? [Colors.blueGrey, Colors.deepPurple]
                                        : [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatDate(checkInDate),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: titleColor,
                                    ),
                                  ),
                                  Text(
                                    dayName(checkInDate.weekday),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: subTitleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: checkOutDate != null
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              checkOutDate != null ? loc.completed : loc.active,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: checkOutDate != null
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: dividerColor, height: 1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeInfo(
                              Icons.login,
                              Colors.green,
                              loc.checkIn,
                              formatTime(checkInDate),
                              checkInLat != null && checkInLng != null,
                              isDark,
                            ),
                          ),
                          if (checkOutDate != null) ...[
                            Container(
                              width: 1,
                              height: 40,
                              color: dividerColor,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              child: _buildTimeInfo(
                                Icons.logout,
                                Colors.red,
                                loc.checkOut,
                                formatTime(checkOutDate),
                                checkOutLat != null && checkOutLng != null,
                                isDark,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: Center(
                                child: Text(
                                  loc.notCheckedOutYet,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: subTitleColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    Colors.blueGrey.withOpacity(0.1),
                                    Colors.deepPurple.withOpacity(0.1),
                                  ]
                                : [
                                    Color(0xFF667eea).withOpacity(0.1),
                                    Color(0xFF764ba2).withOpacity(0.1),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Color(0xFF667eea),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${loc.totalWorkHours}:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: subTitleColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                formatDuration(totalHours),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667eea),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            loc.tapForDetails,
                            style: TextStyle(
                              fontSize: 12,
                              color: subTitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.touch_app, size: 16, color: subTitleColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeInfo(
    IconData icon,
    Color iconColor,
    String label,
    String time,
    bool hasLocation,
    bool isDark,
  ) {
    final subTitleColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.location_on,
              size: 12,
              color: hasLocation ? Colors.green : Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: subTitleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  void _showDetailDialog(
    BuildContext context,
    DateTime checkInDate,
    DateTime? checkOutDate,
    double totalHours,
    double? checkInLat,
    double? checkInLng,
    double? checkOutLat,
    double? checkOutLng,
    AppLocalizations loc,
    bool isDark,
  ) {
    final bgColor = isDark ? Color(0xFF1E1E2C) : Colors.white;
    final titleColor = isDark ? Colors.white : Color(0xFF2D3748);
    final subTitleColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.blueGrey, Colors.deepPurple]
                        : [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.workDayDetails,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            formatDate(checkInDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailSection(
                        context,
                        loc.checkIn,
                        Icons.login,
                        Colors.green,
                        formatTime(checkInDate),
                        checkInLat,
                        checkInLng,
                        loc,
                        isDark,
                      ),
                      if (checkOutDate != null) ...[
                        const SizedBox(height: 20),
                        _detailSection(
                          context,
                          loc.checkOut,
                          Icons.logout,
                          Colors.red,
                          formatTime(checkOutDate),
                          checkOutLat,
                          checkOutLng,
                          loc,
                          isDark,
                        ),
                      ],
                      const SizedBox(height: 20),
                      // إجمالي وقت العمل
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    Colors.blueGrey.withOpacity(0.15),
                                    Colors.deepPurple.withOpacity(0.15),
                                  ]
                                : [
                                    Color(0xFF667eea).withOpacity(0.15),
                                    Color(0xFF764ba2).withOpacity(0.15),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isDark
                                ? Colors.blueGrey.withOpacity(0.3)
                                : Color(0xFF667eea).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: isDark ? Colors.white : Color(0xFF667eea),
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              loc.totalWorkHours,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatDuration(totalHours),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Color(0xFF667eea),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String time,
    double? lat,
    double? lng,
    AppLocalizations loc,
    bool isDark,
  ) {
    final bgColor = isDark ? Color(0xFF2C2C3A) : color.withOpacity(0.05);
    final borderColor = color.withOpacity(0.2);
    final titleColor = isDark ? Colors.white : color;
    final textColor = isDark ? Colors.grey[300]! : Color(0xFF2D3748);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${loc.time}: $time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          if (lat != null && lng != null)
            FutureBuilder<String>(
              future: getAddress(lat, lng),
              builder: (context, snap) {
                final text = snap.connectionState == ConnectionState.done
                    ? (snap.data ?? loc.unknownLocation)
                    : loc.locating;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          else
            Row(
              children: [
                Icon(
                  Icons.location_off,
                  size: 16,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                const SizedBox(width: 6),
                Text(
                  loc.noLocation,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
