import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/Employee/MonthlySchedule/schedule_cubit.dart';
import 'package:projects_flutter/Employee/languge/cubit/language_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class MonthlyScheduleScreen extends StatefulWidget {
  const MonthlyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyScheduleScreen> createState() => _MonthlyScheduleScreenState();
}

class _MonthlyScheduleScreenState extends State<MonthlyScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.email;

    return BlocProvider(
      create: (_) => ScheduleCubit(FirebaseFirestore.instance, uid!),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.monthlySchedule),
          centerTitle: true,
        ),
        body: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ScheduleLoaded) {
              return _buildCalendar(context, state.events);
            } else if (state is ScheduleError) {
              return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${state.message}'));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, Map<String, List<String>> events) {
    final locale = context.watch<LanguageCubit>().state.languageCode;

    return TableCalendar<String>(
      locale: locale,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2090, 12, 31),
      focusedDay: _focusedDay,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) {
        final key = day.toIso8601String().split('T').first;
        return events[key] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _showDayDetails(
          context,
          selectedDay,
          events[selectedDay.toIso8601String().split('T').first] ?? [],
        );
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  void _showDayDetails(BuildContext context, DateTime date, List<String> eventsForDay) {
    final loc = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  '${date.day}-${date.month}-${date.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              Expanded(
                child: eventsForDay.isEmpty
                    ? Center(child: Text(loc.noEvents))
                    : ListView.separated(
                  itemCount: eventsForDay.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final ev = eventsForDay[index];
                    return ListTile(
                      title: Text(ev),
                      leading: const Icon(Icons.event),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddEventDialog(context, date),
                  icon: const Icon(Icons.add),
                  label: Text(loc.addEvent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, DateTime date) {
    final controller = TextEditingController();
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.addEvent),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: loc.eventText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                context.read<ScheduleCubit>().addEvent(date, text);
                Navigator.pop(context);
              }
            },
            child: Text(loc.save),
          ),
        ],
      ),
    );
  }
}
