// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:projects_flutter/l10n/app_localizations.dart';
//
// import '../ModelsHR/Employee.dart';
// import '../SalaryCubit/SalaryCubit.dart';
// import '../SalaryCubit/SalaryState.dart';
// import '../EmployeeCubit/employeescubit.dart';
// import '../EmployeeCubit/employeesstate.dart';
// import 'SalaryReleasePreview.dart';
//
// class SalaryPage extends StatefulWidget {
//   const SalaryPage({super.key});
//
//   @override
//   State<SalaryPage> createState() => _SalaryPageState();
// }
//
// class _SalaryPageState extends State<SalaryPage> with TickerProviderStateMixin {
//   DateTime selectedMonth = DateTime.now();
//   Map<String, bool> selectedEmployees = {};
//   bool selectAll = false;
//   String searchQuery = '';
//   late AnimationController _animationController;
//   late AnimationController _fabAnimationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _fabAnimationController.dispose();
//     super.dispose();
//   }
//
//   void _updateFabVisibility() {
//     final hasSelected = selectedEmployees.values.any((selected) => selected);
//     if (hasSelected) {
//       _fabAnimationController.forward();
//     } else {
//       _fabAnimationController.reverse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;
//
//     final employeesState = context.read<EmployeesCubit>().state;
//     List<Employee> approvedEmployees = [];
//     if (employeesState is EmployeesLoaded) {
//       approvedEmployees = employeesState.employees
//           .where((e) => e.hrStatus == 'approved')
//           .toList();
//     }
//
//     String monthDocId = DateFormat('yyyy-MM').format(selectedMonth);
//
//     return BlocProvider(
//       create: (_) => SalaryCubit()..loadSalaries(monthDocId, approvedEmployees),
//       child: Builder(
//         builder: (context) {
//           return Scaffold(
//             backgroundColor: Colors.grey[50],
//             body: CustomScrollView(
//               slivers: [
//                 // Modern App Bar
//                 SliverAppBar(
//                   expandedHeight: 200,
//                   floating: false,
//                   pinned: true,
//                   elevation: 0,
//                   backgroundColor: Colors.transparent,
//                   leading: Container(
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2D3748)),
//                       onPressed: () => Navigator.of(context).pop(),
//                     ),
//                   ),
//                   flexibleSpace: FlexibleSpaceBar(
//                     background: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.indigo.shade600,
//                             Colors.blue.shade600,
//                             Colors.indigo.shade700,
//                           ],
//                         ),
//                       ),
//                       child: SafeArea(
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 loc.salaryPageTitle,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 28,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 DateFormat('MMMM yyyy', 'ar').format(selectedMonth),
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8),
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Row(
//                                 children: [
//                                   // Month Picker Button
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: InkWell(
//                                       borderRadius: BorderRadius.circular(16),
//                                       onTap: () async {
//                                         final picked = await showMonthPicker(
//                                           context: context,
//                                           initialDate: selectedMonth,
//                                           firstDate: DateTime(2020),
//                                           lastDate: DateTime(2100),
//                                         );
//                                         if (picked != null) {
//                                           setState(() {
//                                             selectedMonth = picked;
//                                             monthDocId = DateFormat('yyyy-MM').format(selectedMonth);
//                                             context.read<SalaryCubit>().loadSalaries(monthDocId, approvedEmployees);
//                                             selectedEmployees.clear();
//                                             selectAll = false;
//                                             _animationController.reset();
//                                             _animationController.forward();
//                                             _updateFabVisibility();
//                                           });
//                                         }
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             const Text(
//                                               'اختر الشهر',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             const Icon(
//                                               Icons.calendar_month_rounded,
//                                               color: Colors.white,
//                                               size: 20,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Search Bar
//                 SliverToBoxAdapter(
//                   child: SlideTransition(
//                     position: _slideAnimation,
//                     child: FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: Container(
//                         margin: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.08),
//                               blurRadius: 15,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           onChanged: (val) {
//                             setState(() {
//                               searchQuery = val;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             prefixIcon: Icon(
//                               Icons.search_rounded,
//                               color: Colors.grey[400],
//                             ),
//                             hintText: loc.searchEmployees,
//                             hintStyle: TextStyle(color: Colors.grey[400]),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.all(16),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Content
//                 SliverToBoxAdapter(
//                   child: BlocBuilder<SalaryCubit, SalaryState>(
//                     builder: (context, state) {
//                       if (state is SalaryLoading) {
//                         return _buildLoadingState();
//                       } else if (state is SalaryLoaded) {
//                         if (state.salaries.isEmpty) {
//                           return _buildEmptyState(loc);
//                         }
//                         return _buildSalariesList(state, approvedEmployees, loc);
//                       } else if (state is SalaryError) {
//                         return _buildErrorState(state.message, loc);
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             floatingActionButton: ScaleTransition(
//               scale: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
//               ),
//               child: FloatingActionButton.extended(
//                 backgroundColor: Colors.indigo.shade600,
//                 foregroundColor: Colors.white,
//                 onPressed: () {
//                   final selected = (context.read<SalaryCubit>().state as SalaryLoaded)
//                       .salaries
//                       .where((emp) => selectedEmployees[emp.email] ?? false)
//                       .toList();
//
//                   if (selected.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => SalaryReleasePreview(
//                           salaries: selected,
//                           approvedEmployees: approvedEmployees,
//                           month: selectedMonth,
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(loc.selectAtLeastOneEmployee),
//                         backgroundColor: Colors.red[400],
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 label: Text(
//                   loc.release,
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 icon: const Icon(Icons.send_rounded),
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 100),
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.indigo.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade600),
//                   strokeWidth: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'جاري تحميل البيانات...',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState(AppLocalizations loc) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 100),
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.receipt_long_rounded,
//                     size: 48,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'لا توجد بيانات رواتب',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   loc.noDataForMonth,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(String message, AppLocalizations loc) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 100),
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.red.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 8),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.red[50],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.error_outline_rounded,
//                     size: 48,
//                     color: Colors.red[400],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'حدث خطأ',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF2D3748),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '${loc.error}: $message',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSalariesList(SalaryLoaded state, List<Employee> approvedEmployees, AppLocalizations loc) {
//     // فلترة حسب البحث
//     final filteredSalaries = state.salaries.where((empSalary) {
//       final employee = approvedEmployees.firstWhere(
//             (e) => e.email == empSalary.email,
//         orElse: () => Employee(
//           id: empSalary.email,
//           name: empSalary.email,
//           email: empSalary.email,
//           phoneNumber: '',
//           iban: '',
//           address: '',
//           birthDate: '',
//           hrStatus: '',
//           profileImage: '',
//           companyCode: '',
//           companyLat: 0,
//           companyLng: 0,
//           createdAt: Timestamp.now(),
//           idImage: '',
//           ratePerHour: 0,
//         ),
//       );
//       return employee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           employee.email.toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();
//
//     // حساب إجمالي الرواتب المختارة
//     double selectedTotal = 0;
//     int selectedCount = 0;
//     for (var emp in filteredSalaries) {
//       if (selectedEmployees[emp.email] ?? false) {
//         selectedTotal += emp.salary;
//         selectedCount++;
//       }
//     }
//
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Summary Card with Selection Info
//             if (selectedCount > 0)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade600, Colors.teal.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.3),
//                       blurRadius: 15,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'المبلغ المختار للصرف',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${selectedTotal.toStringAsFixed(2)} ريال',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'عدد الموظفين المختارين: $selectedCount',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             // Select All Card
//             Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 15,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: CheckboxListTile(
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 value: selectAll,
//                 onChanged: (val) {
//                   setState(() {
//                     selectAll = val ?? false;
//                     for (var emp in filteredSalaries) {
//                       if (!(emp.salaryReleased ?? false)) {
//                         selectedEmployees[emp.email] = selectAll;
//                       }
//                     }
//                     _updateFabVisibility();
//                   });
//                 },
//                 title: Text(
//                   loc.selectAll,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 activeColor: Colors.indigo.shade600,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//
//             // Employees List
//             ...filteredSalaries.asMap().entries.map((entry) {
//               final index = entry.key;
//               final empSalary = entry.value;
//               final employee = approvedEmployees.firstWhere(
//                     (e) => e.email == empSalary.email,
//                 orElse: () => Employee(
//                   id: '',
//                   name: empSalary.email,
//                   email: empSalary.email,
//                   phoneNumber: '',
//                   iban: '',
//                   address: '',
//                   birthDate: '',
//                   hrStatus: '',
//                   profileImage: '',
//                   companyCode: '',
//                   companyLat: 0,
//                   companyLng: 0,
//                   createdAt: Timestamp.now(),
//                   idImage: '',
//                   ratePerHour: 0,
//                 ),
//               );
//
//               final isChecked = selectedEmployees[empSalary.email] ?? false;
//               final isPaid = empSalary.salaryReleased ?? false;
//
//               return TweenAnimationBuilder<double>(
//                 duration: Duration(milliseconds: 300 + (index * 100)),
//                 tween: Tween(begin: 0.0, end: 1.0),
//                 builder: (context, value, child) {
//                   return Transform.translate(
//                     offset: Offset(0, 50 * (1 - value)),
//                     child: Opacity(
//                       opacity: value,
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           border: isPaid
//                               ? Border.all(color: Colors.green.shade200, width: 2)
//                               : isChecked
//                               ? Border.all(color: Colors.indigo.shade200, width: 2)
//                               : null,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.06),
//                               blurRadius: 15,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   // Status Icon/Checkbox
//                                   if (isPaid)
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         color: Colors.green[100],
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.check_circle_rounded,
//                                         color: Colors.green[600],
//                                         size: 24,
//                                       ),
//                                     )
//                                   else
//                                     Transform.scale(
//                                       scale: 1.2,
//                                       child: Checkbox(
//                                         value: isChecked,
//                                         onChanged: (val) {
//                                           setState(() {
//                                             selectedEmployees[empSalary.email] = val ?? false;
//                                             selectAll = filteredSalaries.every(
//                                                   (emp) =>
//                                               emp.salaryReleased == true ||
//                                                   (selectedEmployees[emp.email] ?? false),
//                                             );
//                                             _updateFabVisibility();
//                                           });
//                                         },
//                                         activeColor: Colors.indigo.shade600,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(6),
//                                         ),
//                                       ),
//                                     ),
//
//                                   const SizedBox(width: 16),
//
//                                   // Employee Avatar
//                                   CircleAvatar(
//                                     radius: 24,
//                                     backgroundColor: isPaid
//                                         ? Colors.green.shade100
//                                         : Colors.indigo.shade100,
//                                     backgroundImage: employee.profileImage.isNotEmpty
//                                         ? NetworkImage(employee.profileImage)
//                                         : null,
//                                     child: employee.profileImage.isEmpty
//                                         ? Text(
//                                       employee.name.isNotEmpty
//                                           ? employee.name.substring(0, 1).toUpperCase()
//                                           : 'M',
//                                       style: TextStyle(
//                                         color: isPaid
//                                             ? Colors.green.shade600
//                                             : Colors.indigo.shade600,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )
//                                         : null,
//                                   ),
//
//                                   const SizedBox(width: 16),
//
//                                   // Employee Info
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           employee.name,
//                                           style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF2D3748),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           employee.email,
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   // Salary Amount
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       color: isPaid ? Colors.green[50] : Colors.indigo[50],
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Text(
//                                       '${empSalary.salary.toStringAsFixed(2)} ريال',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: isPaid ? Colors.green[700] : Colors.indigo[700],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const SizedBox(height: 16),
//
//                               // Details Row
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[50],
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 loc.hours,
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey[600],
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 formatHours(empSalary.totalMonthHours),
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Color(0xFF2D3748),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 1,
//                                           height: 40,
//                                           color: Colors.grey[300],
//                                         ),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 loc.hourRate,
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey[600],
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                 '${empSalary.ratePerHour.toStringAsFixed(2)} ريال',
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Color(0xFF2D3748),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     if (isPaid) ...[
//                                       const SizedBox(height: 12),
//                                       Container(
//                                         padding: const EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           color: Colors.green[100],
//                                           borderRadius: BorderRadius.circular(8),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Icon(
//                                               Icons.payment_rounded,
//                                               color: Colors.green[600],
//                                               size: 18,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               child:                                               Text(
//                                                 '${loc.paid}: ${_formatReleaseDate(empSalary.releaseDate)}',
//                                                 style: TextStyle(
//                                                   color: Colors.green[700],
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// String formatHours(double hours) {
//   int h = hours.floor();
//   int m = ((hours - h) * 60).round();
//   return '${h}س ${m}د';
// }
//
// String _formatReleaseDate(dynamic releaseDate) {
//   try {
//     DateTime date;
//     if (releaseDate is Timestamp) {
//       date = releaseDate.toDate();
//     } else if (releaseDate is DateTime) {
//       date = releaseDate;
//     } else {
//       return 'تاريخ غير محدد';
//     }
//     return DateFormat('yyyy-MM-dd').format(date);
//   } catch (e) {
//     return 'تاريخ غير صالح';
//   }
// }