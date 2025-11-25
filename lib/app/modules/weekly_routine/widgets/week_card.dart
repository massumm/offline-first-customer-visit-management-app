import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:icon/app/base/widgets/custom_toast.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/theme/app_text_theme.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/generated/assets.dart';
import '../controllers/weekly_routine_controller.dart';

class WeekCard extends StatelessWidget {
  final String weekName;
  final bool isSelected;
  final VoidCallback onTap;
  final int weekIndex;

  const WeekCard({
    super.key,
    required this.weekName,
    required this.isSelected,
    required this.onTap,
    required this.weekIndex,
  });

  @override
  Widget build(BuildContext context) {
    final nameParts = weekName.split(' ');
    final firstPart = nameParts.isNotEmpty ? nameParts[0] : '';
    final secondPart = nameParts.length > 1 ? nameParts[1] : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        constraints: BoxConstraints(
          minWidth: isSelected ? 120.0 : 90.0,
          maxWidth: isSelected ? 120.0 : 90.0,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBgColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.colorPrimary : AppColors.lightBorderGrayColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: isSelected ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    firstPart,
                    style: AppTextTheme.bodyMediumRegular,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  4.height,
                  Text(
                    secondPart,
                    style: AppTextTheme.bodyMediumSemiBold.copyWith(
                      color: AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if(isSelected)
              ...[
                8.width,

                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: AppColors.verticalDividerColorRed,
                    thickness: 2,
                    width: 2,
                  ),
                ),
                8.width,
                InkWell(
                  onTap: () => showDeleteWeekDialogue(context),
                  child: SvgPicture.asset(
                                Assets.activityTrackerDeleteIcon,
                  colorFilter: ColorFilter.mode(AppColors.colorPrimary, BlendMode.srcIn),

                                ),
                ),]
          ],
        ),
      ),
    );
  }

  void showDeleteWeekDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Container(
            width: 262,
            height: 262,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Light pink outer circle
            ),
            child: Center(
              child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFE4DD), // Light pink outer circle
                  ),
                  child: Center(
                      child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // White middle circle
                          ),
                          child: Center(

                              child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFCD4D4), // Light pink inner circle
                                  ),
                                  child: Center(child: SvgPicture.asset(Assets.svgDeleteDialoguleIcon, height: 50, width: 50,),)))))),
            ),
          ),
          title: Text('Delete This Week?', style: AppTextTheme.headlineMediumSemiBold.copyWith(color: Colors.black)),
          content: Row(
            children: [
              Expanded(child: Text('If you delete this week’s plan, all workouts inside it will be removed.', style: AppTextTheme.bodyLargeRegular, textAlign: TextAlign.center,)),
            ],
          ), //14px, regular
          actions: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.pageBackground,
                      border: Border.all(color: AppColors.lightBorderGrayColor),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: AppTextTheme.titleSmallSemiBold.copyWith(color: AppColors.colorPrimary),
                        // 16px, semi bold, black
                      ),
                    ),
                  ),
                ),
                16.width,
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.warningColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        final controller = Get.find<WeeklyRoutineController>();
                        final deletedWeek = controller.deleteWeek(weekIndex);
                        
                        if (deletedWeek != null) {
                          Navigator.of(context).pop();
                          CustomToast.show(
                            context,
                            message: '${deletedWeek.weekName} deleted successfully',
                            onUndo: () => controller.undoWeek(),
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Delete',
                          style: AppTextTheme.titleSmallSemiBold.copyWith(color: Colors.white), //16 px, semi bold, white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
