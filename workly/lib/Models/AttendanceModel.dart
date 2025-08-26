class AttendanceModel {
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? totalHours;
  final double? checkInLat;
  final double? checkInLng;
  final double? checkOutLat;
  final double? checkOutLng;

  AttendanceModel({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.totalHours,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'totalHours': totalHours,
      'checkInLat': checkInLat,
      'checkInLng': checkInLng,
      'checkOutLat': checkOutLat,
      'checkOutLng': checkOutLng,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> data) {
    return AttendanceModel(
      date: (data['date'] as DateTime?) ?? DateTime.now(),
      checkIn: data['checkIn'] as DateTime?,
      checkOut: data['checkOut'] as DateTime?,
      totalHours: (data['totalHours'] as num?)?.toDouble(),
      checkInLat: (data['checkInLat'] as num?)?.toDouble(),
      checkInLng: (data['checkInLng'] as num?)?.toDouble(),
      checkOutLat: (data['checkOutLat'] as num?)?.toDouble(),
      checkOutLng: (data['checkOutLng'] as num?)?.toDouble(),
    );
  }
}
