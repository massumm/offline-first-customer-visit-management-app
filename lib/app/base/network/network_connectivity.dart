import 'dart:io';

class NetworkConnectivity {
  static Future<void> checkStatus() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (isOnline) {
        // errorToast("Error", "Something went wrong!");
      } else {
        //errorToast("Error", "Check Internet Connection!");
      }
    } on SocketException catch (_) {
      // errorToast("Error", "Check Internet Connection!");
    }
  }
}
