// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'package:get/get.dart';
// import 'package:icon/app/base/base_view.dart';
// import 'package:icon/app/core/widgets/super_image.dart';
//
// import '../../../../generated/assets.dart';
// import '../../../core/values/app_colors.dart';
// import '../controllers/home_controller.dart';
//
// // ... (other parts of your HomeView class)
//
// class HomeView extends BaseView<HomeController> {
//   HomeView({super.key});
//
//   @override
//   Widget body(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView( // This is the main vertical scroll view
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const _Header(),
//               const SizedBox(height: 16),
//               _UserHeader(username: controller.username, day: 12, level: 7),
//               const SizedBox(height: 16),
//               DailyProcressIndicators(controller: controller),
//               const SizedBox(height: 16),
//               TrainerRegCard(onPressed: () {}),
//               const SizedBox(height: 16),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final isWide = constraints.maxWidth > 520;
//                   final actionCards = [
//                     _ActionsCard(
//                       title: 'Activity',
//                       color: const Color(0xFF6E7416), // olive-ish
//                       percent: 0.85,
//                       lines: const [
//                         'Workouts: 2 / 4 this week',
//                         'Today: 5.3 km Run',
//                         'Record: New 5K Best Time!',
//                       ],
//                     ),
//                     _ActionsCard(
//                       title: 'Recovery',
//                       color: const Color(0xFFD0473D), // red-ish
//                       percent: 0.78,
//                       lines: const [
//                         'Readiness Score: 78 / 100',
//                         'Sleep: 7h 20m',
//                         'HRV: 65 ms',
//                       ],
//                     ),
//                   ];
//
//                   if (isWide) {
//                     // Wide layout: Row with Expanded children
//                     return Row(
//                       children: [
//                         Expanded(child: actionCards[0]),
//                         const SizedBox(width: 16),
//                         Expanded(child: actionCards[1]),
//                       ],
//                     );
//                   } else {
//                     // Narrow layout: Horizontally scrolling Row
//                     return SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: constraints.maxWidth * 0.8, // Example: Card takes 80% of screen width
//                             child: actionCards[0],
//                           ),
//                           const SizedBox(width: 16),
//                           SizedBox(
//                             width: constraints.maxWidth * 0.8, // Example: Card takes 80% of screen width
//                             child: actionCards[1],
//                           ),
//                           // Add more cards here if needed, and they will scroll horizontally
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),
//               _GoalsCard(onPressed: () {}, ringValue: 0.64),
//               const SizedBox(height: 16),
//               _CommunityCard(color: cs.secondary),
//               const SizedBox(height: 58),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: NavigationBar(
//         // ... your navigation bar code
//         backgroundColor: const Color(0xFF141518),
//         selectedIndex: 0,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.dashboard_outlined),
//             selectedIcon: Icon(Icons.dashboard),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.favorite_outline),
//             selectedIcon: Icon(Icons.favorite),
//             label: 'Wellness',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.bar_chart_outlined),
//             selectedIcon: Icon(Icons.bar_chart),
//             label: 'Stats',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   PreferredSizeWidget? appBar(BuildContext context) => null;
// }
//
// // Assume _ActionsCard is defined something like this:
// // You might need to adjust its internal layout if it doesn't adapt well to constrained widths.
// class _ActionsCard extends StatelessWidget {
//   final String title;
//   final Color color;
//   final double percent;
//   final List<String> lines;
//
//   const _ActionsCard({
//     required this.title,
//     required this.color,
//     required this.percent,
//     required this.lines,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // This is a placeholder for your actual _ActionsCard implementation
//     // Ensure this card can handle being given a specific width.
//     return Card(
//       color: color.withOpacity(0.2),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             LinearProgressIndicator(value: percent, color: color, backgroundColor: color.withOpacity(0.3), minHeight: 6,),
//             const SizedBox(height: 12),
//             for (String line in lines) ...[
//               Text(line, style: Theme.of(context).textTheme.bodyMedium),
//               const SizedBox(height: 4),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // ... (Rest of your widgets: DailyProcressIndicators, _UserHeader, _InfoChip, DayCard, ProgressRing, _RingPainter, _Header, TrainerRegCard, _GoalsCard, _CommunityCard etc.)
// // Make sure _CommunityCard and _GoalsCard are also well-behaved if their width becomes constrained by the outer SingleChildScrollView.
// // For _QuickStatsStrip (if you re-add it), it already has a horizontal ListView, which is good.
//
// class DailyProcressIndicators extends StatelessWidget {
//   const DailyProcressIndicators({super.key, required this.controller});
//
//   final HomeController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 112,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (_, i) => DayCard(item: controller.week[i]),
//         separatorBuilder: (_, _) => const SizedBox(width: 12),
//         itemCount: controller.week.length,
//       ),
//     );
//   }
// }
//
// class _UserHeader extends StatelessWidget {
//   const _UserHeader({
//     required this.username,
//     required this.day,
//     required this.level,
//   });
//
//   final String username;
//   final int day;
//   final int level;
//
//   @override
//   Widget build(BuildContext context) {
//     final chipStyle = Theme.of(context).textTheme.bodyMedium;
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Good morning,',
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyLarge!.copyWith(color: Colors.white70),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   username,
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//               ],
//             ),
//           ),
//           _InfoChip(
//             icon: Assets.svgMorningIcon,
//             label: 'Day $day',
//             style: chipStyle,
//           ),
//           const SizedBox(width: 8),
//           _InfoChip(
//             icon: Assets.svgLevel7,
//             label: 'Level $level',
//             style: chipStyle,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _InfoChip extends StatelessWidget {
//   const _InfoChip({required this.icon, required this.label, this.style});
//
//   final String icon;
//   final String label;
//   final TextStyle? style;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SuperImage(icon),
//           const SizedBox(width: 6), // This should be height if children are in a Column
//           Text(label, style: style),
//         ],
//       ),
//     );
//   }
// }
//
// class DayCard extends StatelessWidget {
//   const DayCard({super.key, required this.item});
//
//   final DayItem item;
//
//   @override
//   Widget build(BuildContext context) {
//     final isToday = item.isToday;
//
//     return Container(
//       width: 80, // Adjusted width
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Adjusted padding
//       decoration: BoxDecoration(
//         color: isToday ? const Color(0xFF3A1E1E) : Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: isToday
//             ? Border.all(color: const Color(0xFFE35D5D), width: 1)
//             : null,
//       ),
//       child: FittedBox( // Use FittedBox to ensure content fits
//         fit: BoxFit.scaleDown,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: 36, // Adjusted size
//               width: 36,  // Adjusted size
//               child: ProgressRing(
//                 value: item.progress,
//                 thickness: 3, // Adjusted thickness
//                 trackColor: Colors.white10,
//                 valueColor: isToday
//                     ? AppColors.redProgressColor
//                     : AppColors.greenProgressColor,
//               ),
//             ),
//             const SizedBox(height: 8), // Adjusted spacing
//             Text(
//               item.label,
//               style: const TextStyle(color: Colors.white70, fontSize: 12), // Adjusted font size
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 2),
//             Text(
//               '${item.date}',
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), // Adjusted font size
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProgressRing extends StatelessWidget {
//   const ProgressRing({
//     super.key,
//     required this.value,
//     this.thickness = 4,
//     this.trackColor = Colors.white10,
//     this.valueColor = const Color(0xFF6EE7B7),
//     this.child,
//   });
//
//   final double value; // 0..1
//   final double thickness;
//   final Color trackColor;
//   final Color valueColor;
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _RingPainter(
//         value: value.clamp(0.0, 1.0),
//         thickness: thickness,
//         track: trackColor,
//         fill: valueColor,
//       ),
//       child: child,
//     );
//   }
// }
//
// class _RingPainter extends CustomPainter {
//   _RingPainter({
//     required this.value,
//     required this.thickness,
//     required this.track,
//     required this.fill,
//   });
//
//   final double value;
//   final double thickness;
//   final Color track;
//   final Color fill;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.center(Offset.zero);
//     final radius = math.min(size.width, size.height) / 2;
//     final rect = Rect.fromCircle(center: center, radius: radius);
//
//     final trackPaint = Paint()
//       ..color = track
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = thickness
//       ..strokeCap = StrokeCap.round;
//
//     final valuePaint = Paint()
//       ..color = fill
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = thickness
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawArc(
//       rect.deflate(thickness / 2),
//       -math.pi / 2,
//       2 * math.pi,
//       false,
//       trackPaint,
//     );
//
//     canvas.drawArc(
//       rect.deflate(thickness / 2),
//       -math.pi / 2,
//       2 * math.pi * value,
//       false,
//       valuePaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant _RingPainter old) =>
//       old.value != value ||
//           old.fill != fill ||
//           old.track != track ||
//           old.thickness != thickness;
// }
//
// class _Header extends StatelessWidget {
//   const _Header();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SvgPicture.asset(Assets.svgLogo, height: 40),
//         const Spacer(),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.notifications_outlined),
//         ),
//       ],
//     );
//   }
// }
//
//
// class TrainerRegCard extends StatelessWidget {
//   final VoidCallback onPressed;
//
//   const TrainerRegCard({super.key, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       width: double.infinity, // Take full width available from parent
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         gradient: LinearGradient(
//           colors: [const Color(0xFF1F1F1F), AppColors.colorPrimarySwatch.shade300],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         border: Border.all(color: const Color(0XFF2B2B2B)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Apply to Become a Trainer',
//             textAlign: TextAlign.center, // Added for better centering if text wraps
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Share your passion for fitness and help others reach their goals. Join our community of certified trainers.',
//             textAlign: TextAlign.center,
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium!.copyWith(color: Colors.white70),
//           ),
//           const SizedBox(height: 12),
//           FilledButton(
//             onPressed: onPressed,
//             child: const Text(
//               'Apply Now',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class _GoalsCard extends StatelessWidget {
//   final double ringValue;
//   final VoidCallback onPressed;
//
//   const _GoalsCard({required this.ringValue, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     // This is a placeholder structure, adapt to your actual _GoalsCard
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 60,
//               height: 60,
//               child: ProgressRing(value: ringValue, thickness: 6, valueColor: Theme.of(context).colorScheme.primary),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Weekly Goals", style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 4),
//                   Text("${(ringValue * 100).toInt()}% completed", style: Theme.of(context).textTheme.bodyLarge),
//                   const SizedBox(height: 8),
//                   ElevatedButton(onPressed: onPressed, child: const Text("View Goals"))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CommunityCard extends StatelessWidget {
//   final Color color;
//   const _CommunityCard({required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     // This is a placeholder structure
//     return Card(
//       color: color.withOpacity(0.1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Community Hub", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
//             const SizedBox(height: 8),
//             Text("Connect with others, share progress, and find motivation.", style: Theme.of(context).textTheme.bodyMedium),
//             const SizedBox(height: 12),
//             ElevatedButton(onPressed: (){}, child: Text("Join Discussions", style: TextStyle(color: color),), style: ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.3)))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // Dummy HomeController and DayItem for compilation if not fully provided
// class HomeController extends GetxController {
//   final String username = "User";
//   final RxList<DayItem> week = List.generate(7, (index) {
//     return DayItem(
//         label: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
//         date: (10 + index).toString(),
//         progress: math.Random().nextDouble(),
//         isToday: index == 3);
//   }).obs;
// }
//
// class DayItem {
//   final String label;
//   final String date;
//   final double progress;
//   final bool isToday;
//
//   DayItem(
//       {required this.label,
//         required this.date,
//         required this.progress,
//         this.isToday = false});
// }
//
// // Ensure Assets are defined or provide dummy values
// class Assets {
//   static const String svgLogo = 'assets/logo.svg'; // Replace with actual path or dummy
//   static const String svgMorningIcon = 'assets/morning.svg'; // Replace with actual path or dummy
//   static const String svgLevel7 = 'assets/level7.svg'; // Replace with actual path or dummy
// }
