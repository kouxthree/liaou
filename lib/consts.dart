class Consts {
  static const COM = "com.liao";
  static const APP_NAME = "Liao U";
  static const HOME_PAGE = "Home";
  static const SETTING_PAGE = "Setting";
  static const MY_ID_PAGE = "Me";
  static const BACK_TO_HOME = "Back To Home";
  static const RESCAN = "Scan";
  static const DEVICE_LIST_ITEM_HEIGHT = 50.0;//bluetooth listview item height
  static const DEVICE_UNKNOWN = "Device Unknown";
  static const CONNECT = "Connect";
  static const GET_RSSI_SAMPLES = "Get Rssi Samples";
  static const EDGE_INSERT_NUM = 8.0;
  static const SCAN_TIMEOUT = 12;//scan time(seconds)
  static const PERMISSION_MSG = "请你打开蓝牙和定位";//"Bluetooth And Location Is Necessary.";
  static const MY_IMG_FILE = "MY.jpg";
  static const MY_IMG_QUALITY = 25;//5%
  static const MY_IMG_WIDTH = 320.0;
  static const MY_IMG_HEIGHT = 240.0;
}

//stored shared-preference key
enum PrefKey {
  Gender,
  SendSignal,
  SignalType,
}

enum Gender {
  Male,
  Female,
}

enum SendSignal {
  Orange,
  Blue,
  Purple,
  Green,
}

enum SignalType {
  Audio,
  Flash,
}