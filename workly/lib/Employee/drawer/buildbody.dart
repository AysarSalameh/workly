import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/Employee/attendance/attendance_cubit.dart';
import 'package:projects_flutter/Employee/attendance/attendance_state.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/widgets/buildActionButton.dart';
import 'package:projects_flutter/Employee/widgets/buildLocationCard.dart';
import 'package:projects_flutter/Employee/widgets/buildProfileCard.dart';
import 'package:projects_flutter/Employee/widgets/buildTimeRow.dart';
import 'package:projects_flutter/Employee/widgets/buildWarningCard.dart';

Widget buildBody(BuildContext context, AppLocalizations loc, String uid) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, profileState) {
      if (profileState is ProfileLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (profileState is ProfileError) {
        return Center(
          child: Text(
            profileState.message,
            style: TextStyle(fontSize: 18, color: theme.colorScheme.error),
          ),
        );
      }
      if (profileState is! ProfileLoaded) {
        return Center(
          child: Text(
            loc.noData,
            style: TextStyle(fontSize: 18, color: theme.disabledColor),
          ),
        );
      }

      final data = profileState.userData;
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
                buildProfileCard(context, name, company, imageUrl),
                const SizedBox(height: 24),
                buildLocationCard(context, loc, within, () {
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
                      today?.totalHours != null ? '${today!.totalHours!.floor()} ${loc.hours} ${((today.totalHours! - today.totalHours!.floor()) * 60).round()} ${loc.minutes}' : '--',
                      Icons.timer,
                      isDark ? Colors.tealAccent : const Color(0xFF667eea),
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
                        LinearGradient(
                          colors: checkedIn || checkedOut
                              ? [theme.disabledColor, theme.disabledColor.withOpacity(0.7)]
                              : [Color(0xFF56ab2f), Color(0xFFa8e6cf)],
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
                        LinearGradient(
                          colors: checkedIn
                              ? [Color(0xFFff6b6b), Color(0xFFffa5a5)]
                              : [theme.disabledColor, theme.disabledColor.withOpacity(0.7)],
                        ),
                        checkedIn
                            ? () => context.read<AttendanceCubit>().checkOut(uid: uid)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (!within) buildWarningCard(context, loc),

              ],
            ),
          );
        },
      );
    },
  );
}

