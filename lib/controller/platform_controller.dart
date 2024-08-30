// controllers/item_controller.dart
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PlatformController extends GetxController {
  

  bool platform = true;

  bool CheckPlatform() {
    if(Platform.isAndroid) {
      return true;
    }
    else {
      return false;
    }

  }

}
