import 'dart:async';
import 'dart:io' show Platform;
import 'package:beacon_broadcast/beacon_broadcast.dart';
import '../consts.dart';

class Info {
  String uuid = '39ED98FF-FFFF-441A-802F-9C398FC199D2';
  int majorId = 1;
  int minorId = 100;
  int transmissionPower = -59;
  String identifier = Consts.COM;
  AdvertiseMode advertiseMode = AdvertiseMode.lowPower;
  late String layout;
  int manufacturerId = 0x0118;
  List<int> extraData = [100];

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  BeaconStatus isTransmissionSupported = BeaconStatus.notSupportedBle;
  bool isAdvertising = false;
  late StreamSubscription<bool> isAdvertisingSubscription;

  Info() {
    //platform
    if (Platform.isAndroid) {
      layout = BeaconBroadcast.ALTBEACON_LAYOUT;
    } else if (Platform.isIOS) {
      layout = 'm:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24';
      manufacturerId = 0x004c;
    }
  }
}
