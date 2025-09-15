class EmployeeSalary {
  final String uid;
  final String email;
  final double totalMonthHours;
  final double ratePerHour;

  // جديد: خصائص صرف الراتب
  final bool salaryReleased;        // هل تم صرف الراتب؟
  final DateTime? releaseDate;      // تاريخ الصرف (اختياري)
  final double? releasedAmount;     // قيمة الراتب المدفوع (اختياري)

  EmployeeSalary({
    required this.uid,
    required this.email,
    required this.totalMonthHours,
    required this.ratePerHour,
    this.salaryReleased = false,    // افتراضي: لم يصرف بعد
    this.releaseDate,
    this.releasedAmount,
  });

  double get salary => totalMonthHours * ratePerHour;
}
