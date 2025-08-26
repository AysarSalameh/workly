import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/attendance/attendance_cubit.dart';
import 'package:projects_flutter/attendance/attendance_state.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/widgets/buildActionButton.dart';
import 'package:projects_flutter/widgets/buildLocationCard.dart';
import 'package:projects_flutter/widgets/buildProfileCard.dart';
import 'package:projects_flutter/widgets/buildTimeRow.dart';
import 'package:projects_flutter/widgets/buildWarningCard.dart';

Widget buildBody(BuildContext context, AppLocalizations loc, String uid, AsyncSnapshot<Map<String, dynamic>?> snap) {
  if (snap.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  }

  if (snap.hasError || !snap.hasData || snap.data == null) {
    return Center(
      child: Text(
        loc.noData,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  final data = snap.data!;
  final name = data['name'] ?? loc.employee;
  final company = data['companyCode'] ?? '';
  final imageUrl = data['profileImage'] ?? '';

  return BlocBuilder<AttendanceCubit, AttendanceState>(
    builder: (context, state) {
      if (state is AttendanceLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final today = state is AttendanceLoaded ? state.today : null;
      final checkedIn = today?.checkIn != null && today?.checkOut == null;
      final checkedOut = today?.checkOut != null;
      final within = state is AttendanceLoaded ? state.isWithinOffice : false;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildProfileCard(name, company, imageUrl),
            const SizedBox(height: 24),
            buildLocationCard(loc, within, () {
              context.read<AttendanceCubit>().updateLocation(uid: uid);
            }),
            const SizedBox(height: 24),
            Column(
              children: [
                buildTimeRow(
                  loc.checkIn,
                  today?.checkIn != null
                      ? TimeOfDay.fromDateTime(today!.checkIn!).format(context)
                      : '--',
                  Icons.login,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                buildTimeRow(
                  loc.checkOut,
                  today?.checkOut != null
                      ? TimeOfDay.fromDateTime(today!.checkOut!).format(context)
                      : '--',
                  Icons.logout,
                  Colors.red,
                ),
                const SizedBox(height: 12),
                buildTimeRow(
                  loc.totalHours,
                  "${today?.totalHours?.toStringAsFixed(2) ?? '--'} ${loc.hours}",
                  Icons.timer,
                  const Color(0xFF667eea),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: buildActionButton(
                    context,
                    loc.checkIn,
                    Icons.login,
                    const LinearGradient(
                      colors: [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
                    ),
                    checkedIn || checkedOut
                        ? null
                        : () => context.read<AttendanceCubit>().checkIn(uid: uid),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildActionButton(
                    context,
                    loc.checkOut,
                    Icons.logout,
                    const LinearGradient(
                      colors: [Color(0xFFff6b6b), Color(0xFFffa5a5)],
                    ),
                    checkedIn
                        ? () => context.read<AttendanceCubit>().checkOut(uid: uid)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (!within) buildWarningCard(loc),
          ],
        ),
      );
    },
  );
}