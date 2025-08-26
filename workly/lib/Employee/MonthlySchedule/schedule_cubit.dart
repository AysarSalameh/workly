import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final FirebaseFirestore _firestore;
  final String uid;

  ScheduleCubit(this._firestore, this.uid) : super(ScheduleInitial()) {
    loadEvents();
  }

  Map<String, List<String>> events = {};

  Future<void> loadEvents() async {
    emit(ScheduleLoading());
    try {
      final querySnapshot = await _firestore
          .collection('Employee')
          .doc(uid)
          .collection('events')
          .get();

      final Map<String, List<String>> loadedEvents = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final date = data['date'] as String?;
        final eventList = List<String>.from(data['events'] ?? []);
        if (date != null) {
          loadedEvents[date] = eventList;
        }
      }

      events = loadedEvents;
      emit(ScheduleLoaded(events));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  List<String> getEventsForDay(DateTime day) {
    final key = day.toIso8601String().split('T').first;
    return events[key] ?? [];
  }

  Future<void> addEvent(DateTime date, String text) async {
    final key = date.toIso8601String().split('T').first;

    // تحديث الخريطة محليًا
    events.putIfAbsent(key, () => []).add(text);

    // حفظ الحدث في Firestore
    final docRef = _firestore
        .collection('Employee')
        .doc(uid)
        .collection('events')
        .doc(key);

    await docRef.set({
      'date': key,
      'events': FieldValue.arrayUnion([text]),
    }, SetOptions(merge: true));

    emit(ScheduleLoaded(events));
  }
}
