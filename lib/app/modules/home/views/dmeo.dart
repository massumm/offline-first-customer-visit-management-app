// import 'package:flutter/material.dart';
//
// void main() => runApp(const NabberDemo());
//
// class NabberDemo extends StatelessWidget {
//   const NabberDemo({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Bottom Nabber',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF0F0F10),
//         useMaterial3: true,
//       ),
//       home: const _Home(),
//     );
//   }
// }
//
// class _Home extends StatefulWidget {
//   const _Home();
//
//   @override
//   State<_Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<_Home> {
//   int currentIndex = 3; // Profile active by default, like the screenshot
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // so the FAB notch blends cleanly
//       body: Center(
//         child: Text(
//           'Tab: ${["Home","Analytic","Community","Profile"][currentIndex]}',
//           style: const TextStyle(fontSize: 22),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: const _CenterOrb(),
//       bottomNavigationBar: _BottomPillBar(
//         index: currentIndex,
//         onTap: (i) => setState(() => currentIndex = i),
//       ),
//     );
//   }
// }
//
// /// The colorful glowing button in the center
// class _CenterOrb extends StatelessWidget {
//   const _CenterOrb();
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 72,
//       height: 72,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const SweepGradient(
//             colors: [
//               Color(0xFFFF7A7A), // warm reds/pinks
//               Color(0xFFFFC96B),
//               Color(0xFF72E6FF),
//               Color(0xFFA77BFF),
//               Color(0xFFFF7A7A),
//             ],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFFFC7B7B).withOpacity(0.35),
//               blurRadius: 24,
//               spreadRadius: 2,
//             )
//           ],
//         ),
//         child: Center(
//           child: Container(
//             width: 60,
//             height: 60,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 radius: 0.9,
//                 colors: [Colors.white, Color(0x80FFFFFF), Colors.transparent],
//                 stops: [0.0, 0.45, 1.0],
//               ),
//             ),
//             child: const Icon(Icons.bolt_rounded, size: 34, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// The pill-shaped navigation bar with a notch for the orb
// class _BottomPillBar extends StatelessWidget {
//   const _BottomPillBar({
//     required this.index,
//     required this.onTap,
//   });
//
//   final int index;
//   final ValueChanged<int> onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final bg = const Color(0xFF111214);
//     final border = Colors.white.withOpacity(0.08);
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: BottomAppBar(
//           color: Colors.transparent,
//           height: 84,
//           elevation: 0,
//           shape: const CircularNotchedRectangle(),
//           notchMargin: 10,
//           child: Container(
//             decoration: BoxDecoration(
//               color: bg,
//               borderRadius: BorderRadius.circular(24),
//               border: Border.all(color: border, width: 1),
//               boxShadow: const [
//                 BoxShadow(blurRadius: 24, color: Colors.black54),
//               ],
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 _Item(
//                   label: 'Home',
//                   icon: Icons.home_outlined,
//                   selected: index == 0,
//                   onTap: () => onTap(0),
//                 ),
//                 const SizedBox(width: 8),
//                 _Item(
//                   label: 'Analytic',
//                   icon: Icons.show_chart_rounded,
//                   selected: index == 1,
//                   onTap: () => onTap(1),
//                 ),
//                 const Spacer(), // leaves the center space for the notch/orb
//                 _Item(
//                   label: 'Community',
//                   icon: Icons.groups_rounded,
//                   selected: index == 2,
//                   onTap: () => onTap(2),
//                 ),
//                 const SizedBox(width: 8),
//                 _ProfileItem(
//                   label: 'Profile',
//                   selected: index == 3,
//                   onTap: () => onTap(3),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Item extends StatelessWidget {
//   const _Item({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     const inactive = Color(0xFFB9BDC6);
//     const active = Color(0xFFE44A3A); // soft red like the screenshot
//
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: 24, color: selected ? active : inactive),
//             const SizedBox(height: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//                 color: selected ? active : inactive,
//                 letterSpacing: 0.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Profile item shows a small avatar with a red ring when active
// class _ProfileItem extends StatelessWidget {
//   const _ProfileItem({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });
//
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     const inactive = Color(0xFFB9BDC6);
//     const active = Color(0xFFE44A3A);
//
//     return InkWell(
//       borderRadius: BorderRadius.circular(14),
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Avatar with ring
//             Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: selected ? active : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               child: const CircleAvatar(
//                 radius: 12,
//                 backgroundImage: NetworkImage(
//                   'https://i.pravatar.cc/100?img=12',
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w500,
//                 color: selected ? active : inactive,
//                 letterSpacing: 0.2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
