import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/WidgetsAttendance/buildInfoRow.dart';
import 'package:projects_flutter/HR/screen/MonthlyAttendanceScreen.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildAvatarFallback.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AnimatedEmployeeCard extends StatefulWidget {
  final Employee emp;
  final int index;
  final AppLocalizations loc;

  const AnimatedEmployeeCard({
    super.key,
    required this.emp,
    required this.index,
    required this.loc,
  });

  @override
  State<AnimatedEmployeeCard> createState() => _AnimatedEmployeeCardState();
}

class _AnimatedEmployeeCardState extends State<AnimatedEmployeeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 + widget.index * 50),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    bool isPresent = false;

    if (widget.emp.lastCheckIn != null) {
      final lastCheckInDate = DateTime(
        widget.emp.lastCheckIn!.year,
        widget.emp.lastCheckIn!.month,
        widget.emp.lastCheckIn!.day,
      );

      isPresent = lastCheckInDate == todayDate;
    }

    final checkInStr = widget.emp.lastCheckIn != null
        ? DateFormat('MMM dd, HH:mm').format(widget.emp.lastCheckIn!)
        : widget.loc.nocheckintoday;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MonthlyAttendanceScreen(
                  empEmail: widget.emp.email,
                  empName: widget.emp.name,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: isPresent
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: isPresent
                          ? [Colors.green.shade400, Colors.green.shade600]
                          : [Colors.red.shade400, Colors.red.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isPresent ? Colors.green : Colors.red)
                            .withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: widget.emp.profileImage.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.emp.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          buildAvatarFallback(widget.emp, isPresent),
                    ),
                  )
                      : buildAvatarFallback(widget.emp, isPresent),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.emp.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPresent
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isPresent
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.red.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              isPresent
                                  ? widget.loc.present
                                  : widget.loc.absent,
                              style: TextStyle(
                                color: isPresent
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      buildInfoRow(Icons.business_rounded,
                          "${widget.loc.idNumber} ${widget.emp.companyCode}",
                          Colors.blue),
                      const SizedBox(height: 6),
                      buildInfoRow(
                        Icons.access_time_rounded,
                        checkInStr,
                        isPresent ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
