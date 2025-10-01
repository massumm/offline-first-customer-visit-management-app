import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon/app/core/extensions/app_extansions.dart';
import 'package:icon/app/core/values/app_colors.dart';
import 'package:icon/app/core/widgets/back_pill.dart';
import 'package:icon/app/core/widgets/custom_text_field.dart';
import 'package:icon/app/modules/trainer_onboarding/controllers/trainer_onboarding_controller.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/identity_verification_full_name.dart';
import 'package:icon/app/modules/trainer_onboarding/views/screens/specialism_screen.dart';

class QualificationsScreen extends GetView<TrainerOnboardingController> {
  const QualificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrainerOnboardingController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackPill(onTap: () => Navigator.maybePop(context)),
              30.height,
              const ProgressBar(currentStep: 2, stepText: "Identity & Verification"),
              30.height,
              Center(
                child: Text(
                  "What qualifications do you hold?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.pageBackground),
                ),
              ),
              20.height,
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: controller.qualifications.map((q) {
                  return Obx(() {
                    final isSelected =
                    controller.selectedQualifications.contains(q);
                    return GestureDetector(
                      onTap: () => controller.toggleQualification(q),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.transparent : AppColors.cardBgColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            width: 1.5,
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          q,
                          style: TextStyle(
                            color: isSelected ? Colors.deepOrange : Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  });
                }).toList(),
              ),
              20.height,
              Text("Other", style: TextStyle(color: AppColors.pageBackground, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              CustomTextField(
                controller: controller.otherController,
                label: "Other",
                hint: "",
              ),
              20.height,
              const Text("Upload Certifications", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.pageBackground)),
              10.height,
              GestureDetector(
                onTap: () {
                  // demo: add fake file
                  controller.addFile("Certificate${controller.uploadedFiles.length + 1}", "4 MB");
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, color: AppColors.colorPrimary, size: 40),
                      08.height,
                      Text("Upload Certifications File", style: TextStyle(color: Colors.white70)),
                      12.height,
                      // Uploaded Files List
                      SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Obx(() => ListView.builder(
                          itemCount: controller.uploadedFiles.length,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final file = controller.uploadedFiles[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.black11,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.picture_as_pdf,
                                          color: Colors.deepOrange),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(file["name"] ?? "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(file["size"] ?? "",
                                              style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.removeFile(index),
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                      ),
                      // Info notes
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.black11,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: AppColors.colorPrimary, size: 18),
                                06.width,
                                Expanded(child: Text("Uploads can be PDF, JPG, or PNG", style: TextStyle(color: Colors.white70, fontSize: 12))),
                              ],
                            ),
                            6.height,
                            Row(
                              children: const [
                                Icon(Icons.check_circle, color: AppColors.colorPrimary, size: 18),
                                SizedBox(width: 6),
                                Expanded(child: Text("Multiple uploads allowed per specialty", style: TextStyle(color: Colors.white70, fontSize: 12))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.height,
              // Next Button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => SpecialismScreen());
                },
                child: const Text('Next'),
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
