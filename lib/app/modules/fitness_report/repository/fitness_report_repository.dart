abstract class FitnessReportRepository {
  Future<void> generateReport(
      Map<String, dynamic> data, {
        void Function(int, int)? onSendProgress,
      });
}