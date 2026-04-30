import 'package:dio/dio.dart';
import 'package:local_db_test/core/constant.dart';

import '../models/customer_model.dart';

class CustomerRemoteDataSource {
  final Dio dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<List<CustomerModel>> fetchCustomers() async {
    final response = await dio.get('/customers');
    final List data = response.data;
    return data.map((e) => CustomerModel.fromJson(e)).toList();
  }

  Future<void> updateCustomerStatus(Map<String, dynamic> payload) async {
    // PATCH /customers/:id — json-server v1 supports this natively for partial updates
    await dio.patch(
      '/customers/${payload['id']}',
      data: {
        'visitStatus': payload['visitStatus'],
        'notes': payload['notes'],
        'lastVisitDate': payload['lastVisitDate'],
      },
    );
  }

  Future<void> createVisit(Map<String, dynamic> payload) async {
    await dio.post('/visits', data: payload);
  }
}
