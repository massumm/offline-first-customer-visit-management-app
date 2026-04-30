import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:local_db_test/core/sync/sync_service.dart';
import 'package:local_db_test/data/models/customer_model.dart';
import 'package:local_db_test/data/repository/customer_repository_impl.dart';

class CustomerController extends GetxController {
  final repo = CustomerRepository();

  var customers = <CustomerModel>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  var pendingCount = 0.obs;
  var isOnline = false.obs;

  // Search and filter — changing these rebuilds the filtered list in the UI
  var searchQuery = ''.obs;
  var selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    loadCustomers();
    _listenConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    isOnline.value = _hasInternet(result);
  }

  void _listenConnectivity() {
    // BUG FIX: connectivity_plus v6 emits List<ConnectivityResult>, not a single value
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final connected = _hasInternet(results);
      isOnline.value = connected;
      if (connected) {
        // Auto-sync when internet reconnects
        _syncAndReload();
      }
    });
  }

  bool _hasInternet(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet);
  }

  Future<void> _syncAndReload() async {
    isSyncing.value = true;
    await SyncService().syncPendingData();
    isSyncing.value = false;
    await loadCustomers();
  }

  Future<void> loadCustomers() async {
    isLoading.value = true;
    final data = await repo.loadCustomers();
    customers.assignAll(data);
    pendingCount.value = await repo.getPendingCount();
    isLoading.value = false;
  }

  // BUG FIX: this method was called in the detail screen but never existed in the controller
  Future<void> updateCustomer(CustomerModel customer) async {
    await repo.updateCustomer(customer);
    await loadCustomers();
  }

  Future<void> createVisit({
    required int customerId,
    required String status,
    required String notes,
  }) async {
    await repo.createVisit(
      customerId: customerId,
      status: status,
      notes: notes,
    );
    await loadCustomers();
  }

  Future<void> manualSync() async {
    await _syncAndReload();
  }

  // Computed filtered list — used inside Obx() in the list screen.
  // Obx automatically re-runs when customers, searchQuery, or selectedFilter changes.
  List<CustomerModel> get filteredCustomers {
    var list = customers.toList();

    final query = searchQuery.value.toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.name.toLowerCase().contains(query) || c.phone.contains(query),
          )
          .toList();
    }

    final filter = selectedFilter.value;
    if (filter != 'all') {
      list = list.where((c) => c.visitStatus == filter).toList();
    }

    return list;
  }
}
