import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Get.isDarkMode
            ? SvgPicture.asset(Assets.svgIconDark)
            : SvgPicture.asset(Assets.svgLogo),
        const Spacer(),

        // GestureDetector(
        //   onTap: () {},
        //   child: Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //       border: Border.all(
        //         color: AppColors.lightBorderGrayColor,
        //         width: 2,
        //       ),
        //     ),
        //     child: SvgPicture.asset(Assets.homeNotificationIconWithAlert),
        //   ),
        // ),
      ],
    );
  }
}
