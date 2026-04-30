// Abstract contract — the data layer implements this, the domain layer depends on it
abstract class ICustomerRepository {
  Future<List> loadCustomers();
  Future<void> updateCustomer(dynamic customer);
  Future<void> createVisit({
    required int customerId,
    required String status,
    required String notes,
  });
  Future<int> getPendingCount();
}
