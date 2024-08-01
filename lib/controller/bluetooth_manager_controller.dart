import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  BluetoothConnection? _connection;

  BluetoothConnection? get connection => _connection;

  bool get isConnected => _connection != null && _connection!.isConnected;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to the device');
      print(device.address);
    } catch (e) {
      print('Error connecting: $e');
    }
  }

}
 
 



 