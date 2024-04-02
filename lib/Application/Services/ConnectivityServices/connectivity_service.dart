import 'package:connectivity_plus/connectivity_plus.dart';

 

class AppConnectivity {
 
  Future<bool> connectionChanged() async {
     print('<<<<<<<<<'); 
    var connectivityResult = await Connectivity().checkConnectivity();
    print('CONNECTIVITY: $connectivityResult');
   
    if (connectivityResult[0] == ConnectivityResult.none) {
      print('not connected');
      return false;
    } else if (connectivityResult[0] == ConnectivityResult.wifi) {
      print('connected');
      return true;
    } else {
 
      return true;  
  
    }
    
  }
 
} 



// import 'package:connectivity_plus/connectivity_plus.dart';

// class AppConnectivity {
//   static void connectionChanged({
//     void Function()? onDisconnected,
//     void Function()? onConnected,
//   }) {
//     Connectivity().onConnectivityChanged.listen((result) {
//       print('Connectivity: $result');
//       if (result == ConnectivityResult.none) {
//         onDisconnected?.call();
//       } else {
//         onConnected?.call();
//       }
//     });
//   }
// }
