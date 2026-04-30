import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/customer_model.dart';
import '../controllers/customer_controller.dart';

class CustomerDetailScreen extends StatefulWidget {
  final CustomerModel customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final controller = Get.find<CustomerController>();
  late TextEditingController notesController;
  String selectedStatus = 'pending';

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.customer.notes);
    selectedStatus = widget.customer.visitStatus;
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Customer Detail'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildSyncStatusCard(),
            const SizedBox(height: 16),
            _buildEditCard(),
          ],
        ),
      ),
    );
  }

  // Shows all customer info fields (read-only)
  Widget _buildInfoCard() {
    final c = widget.customer;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _infoRow(Icons.phone, c.phone),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _infoRow(
              Icons.email_outlined,
              c.email.isNotEmpty ? c.email : 'N/A',
            ),
            const SizedBox(height: 8),
            _infoRow(
              Icons.location_on_outlined,
              c.address.isNotEmpty ? c.address : 'N/A',
            ),
            const SizedBox(height: 8),
            _infoRow(
              Icons.calendar_today_outlined,
              c.lastVisitDate.isNotEmpty
                  ? _formatDate(c.lastVisitDate)
                  : 'No visit recorded yet',
            ),
            if (c.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoRow(Icons.notes_outlined, c.notes),
            ],
          ],
        ),
      ),
    );
  }

  // Shows whether this customer's data is synced with the server
  Widget _buildSyncStatusCard() {
    final syncStatus = widget.customer.syncStatus;

    Color color;
    IconData icon;
    String label;
    String description;

    switch (syncStatus) {
      case 'synced':
        color = Colors.green;
        icon = Icons.cloud_done_outlined;
        label = 'Synced';
        description = widget.customer.lastSyncedAt.isNotEmpty
            ? 'Last synced: ${_formatDate(widget.customer.lastSyncedAt)}'
            : 'Data is up to date with server';
        break;
      case 'pending_create':
        color = Colors.blue;
        icon = Icons.cloud_upload_outlined;
        label = 'Pending Create';
        description = 'New visit will be uploaded when online';
        break;
      case 'pending_update':
        color = Colors.orange;
        icon = Icons.cloud_upload_outlined;
        label = 'Pending Sync';
        description = 'Changes saved locally, will sync when online';
        break;
      case 'failed':
        color = Colors.red;
        icon = Icons.cloud_off_outlined;
        label = 'Sync Failed';
        description = 'Could not sync after ${ 3} retries. Will retry on next sync.';
        break;
      default:
        color = Colors.grey;
        icon = Icons.cloud_outlined;
        label = syncStatus;
        description = '';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          label,
          style:
              TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Editable section: visit status dropdown + notes + action buttons
  Widget _buildEditCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Visit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Visit Status',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'visited', child: Text('Visited')),
                  DropdownMenuItem(
                    value: 'not_available',
                    child: Text('Not Available'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedStatus = value!),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Save Changes = update customer status (PUT /customers/{id}/visit-status)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveUpdate,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Log Visit = create a new visit entry (POST /visits)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _logVisit,
                    icon: const Icon(Icons.add_location_outlined),
                    label: const Text('Log Visit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Save Changes = update status  •  Log Visit = record a new visit',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  // Queues a PUT /customers/{id}/visit-status in the sync queue
  Future<void> _saveUpdate() async {
    final customer = widget.customer;
    customer.visitStatus = selectedStatus;
    customer.notes = notesController.text;
    customer.lastVisitDate = DateTime.now().toIso8601String();
    await controller.updateCustomer(customer);
    Get.back();
    Get.snackbar(
      'Saved',
      'Changes saved locally. Will sync when online.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Queues a POST /visits in the sync queue
  Future<void> _logVisit() async {
    final id = widget.customer.id;
    if (id == null) return;
    await controller.createVisit(
      customerId: id,
      status: selectedStatus,
      notes: notesController.text,
    );
    Get.back();
    Get.snackbar(
      'Visit Logged',
      'Visit recorded locally. Will sync when online.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
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
