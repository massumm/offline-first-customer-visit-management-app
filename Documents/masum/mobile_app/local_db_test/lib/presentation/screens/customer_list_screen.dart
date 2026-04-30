import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_db_test/data/models/customer_model.dart';
import 'package:local_db_test/presentation/screens/customer_details_screen.dart';

import '../controllers/customer_controller.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final controller = Get.put(CustomerController());
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildOfflineBanner(),
          _buildSearchBar(),
          _buildFilterChips(),
          _buildSyncInfo(),
          Expanded(child: _buildCustomerList()),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Customer List'),
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
      actions: [
        Obx(() {
          if (controller.isSyncing.value) {
            return const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            );
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.sync),
                tooltip: 'Sync Now',
                onPressed: controller.manualSync,
              ),
              Obx(() {
                if (controller.pendingCount.value == 0) return const SizedBox();
                return Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${controller.pendingCount.value}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  // Orange banner shown when device has no internet
  Widget _buildOfflineBanner() {
    return Obx(() {
      if (controller.isOnline.value) return const SizedBox();
      return Container(
        width: double.infinity,
        color: Colors.orange[700],
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              'Offline Mode — showing local data',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search by name or phone...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isEmpty
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      controller.searchQuery.value = '';
                    },
                  ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) => controller.searchQuery.value = value,
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Pending', 'value': 'pending'},
      {'label': 'Visited', 'value': 'visited'},
      {'label': 'Not Available', 'value': 'not_available'},
    ];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: filters.map((f) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == f['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(f['label']!),
                selected: isSelected,
                onSelected: (_) =>
                    controller.selectedFilter.value = f['value']!,
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue[700] : Colors.black87,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildSyncInfo() {
    return Obx(() {
      final total = controller.customers.length;
      final pending = controller.pendingCount.value;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$total customers',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (pending > 0)
              Row(
                children: [
                  Icon(Icons.pending_outlined,
                      size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text(
                    '$pending pending sync',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 14, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    'All synced',
                    style:
                        TextStyle(color: Colors.green[600], fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCustomerList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = controller.filteredCustomers;

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                controller.customers.isEmpty
                    ? 'No customers yet.\nSync to load data.'
                    : 'No results for "${controller.searchQuery.value}"',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 15),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadCustomers,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildCustomerCard(list[index]),
        ),
      );
    });
  }

  Widget _buildCustomerCard(CustomerModel customer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Get.to(() => CustomerDetailScreen(customer: customer))
              ?.then((_) => controller.loadCustomers());
        },
        leading: CircleAvatar(
          backgroundColor:
              _statusColor(customer.visitStatus).withValues(alpha: 0.15),
          child: Text(
            customer.name.isNotEmpty
                ? customer.name[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: _statusColor(customer.visitStatus),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _subtitleRow(Icons.phone, customer.phone),
            const SizedBox(height: 2),
            _subtitleRow(Icons.location_on_outlined, customer.address,
                ellipsize: true),
            if (customer.lastVisitDate.isNotEmpty) ...[
              const SizedBox(height: 2),
              _subtitleRow(
                Icons.calendar_today_outlined,
                _formatDate(customer.lastVisitDate),
                color: Colors.grey,
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _statusChip(customer.visitStatus),
            const SizedBox(height: 4),
            if (customer.syncStatus != 'synced')
              _syncBadge(customer.syncStatus),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _subtitleRow(IconData icon, String text,
      {bool ellipsize = false, Color? color}) {
    final textWidget = Text(
      text,
      style: TextStyle(fontSize: 12, color: color ?? Colors.black87),
      overflow: ellipsize ? TextOverflow.ellipsis : null,
    );
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        ellipsize ? Expanded(child: textWidget) : textWidget,
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'visited':
        return Colors.green;
      case 'not_available':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'visited':
        return 'Visited';
      case 'not_available':
        return 'Not Available';
      default:
        return 'Pending';
    }
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _syncBadge(String syncStatus) {
    final isFailed = syncStatus == 'failed';
    final color = isFailed ? Colors.red : Colors.orange;
    final label = isFailed
        ? 'Failed'
        : (syncStatus == 'pending_create' ? 'New' : 'Pending');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
