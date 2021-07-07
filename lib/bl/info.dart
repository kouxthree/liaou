import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:blemulator/blemulator.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart' as blelib;

class SensorTag extends SimulatedPeripheral {
  static const String _serviceUuid = "F000AA00-0451-4000-B000-000000000000";
  static const String _temperatureDataUuid =
      "F000AA01-0451-4000-B000-000000000000";
  static const String _temperatureConfigUuid =
      "F000AA02-0451-4000-B000-000000000000";
  static const String _temperaturePeriodUuid =
      "F000AA03-0451-4000-B000-000000000000";

  bool _readingTemperature = true;

  SensorTag(
      {String id = "4B:99:4C:34:DE:77",
        String name = "SensorTag",
        String localName = "SensorTag"})
      : super(
      name: name,
      id: id,
      advertisementInterval: Duration(milliseconds: 800),
      services: [
        SimulatedService(
            uuid: _serviceUuid,
            isAdvertised: true,
            characteristics: [
              SimulatedCharacteristic(
                uuid: _temperatureDataUuid,
                value: Uint8List.fromList([0, 0, 0, 0]),
                convenienceName: "IR Temperature Data",
                isWritableWithoutResponse: false,
                isWritableWithResponse: false,
                isNotifiable: true,
              ),
              SimulatedCharacteristic(
                  uuid: _temperatureConfigUuid,
                  value: Uint8List.fromList([0]),
                  convenienceName: "IR Temperature Config"),
              SimulatedCharacteristic(
                  uuid: _temperaturePeriodUuid,
                  value: Uint8List.fromList([50]),
                  convenienceName: "IR Temperature Period"),
            ],
            convenienceName: "Temperature service"),
      ]) {
    scanInfo.localName = localName;

    getCharacteristicForService(_serviceUuid, _temperatureConfigUuid)
        .monitor()
        .listen((value) {
      _readingTemperature = value[0] == 1;
    });

    _emitTemperature();
  }

  void _emitTemperature() async {
    while (true) {
      Uint8List delayBytes = await getCharacteristicForService(
          _serviceUuid, _temperaturePeriodUuid)
          .read();
      int delay = delayBytes[0] * 10;
      await Future.delayed(Duration(milliseconds: delay));
      SimulatedCharacteristic temperatureDataCharacteristic =
      getCharacteristicForService(_serviceUuid, _temperatureDataUuid);
      if (temperatureDataCharacteristic.isNotifying) {
        if (_readingTemperature) {
          temperatureDataCharacteristic
              .write(Uint8List.fromList([101, 254, 64, Random().nextInt(255)]));
        } else {
          temperatureDataCharacteristic.write(Uint8List.fromList([0, 0, 0, 0]));
        }
      }
    }
  }

  @override
  Future<bool> onConnectRequest() async {
    await Future.delayed(Duration(milliseconds: 200));
    return super.onConnectRequest();
  }
}
class GenericPeripheral extends SimulatedPeripheral {
  GenericPeripheral(
      {String name = 'Generic Peripheral',
        String id = 'generic-peripheral-id',
        int milliseconds = 1000,
        List<SimulatedService> services = const []})
      : super(
    name: name,
    id: id,
    advertisementInterval: Duration(milliseconds: milliseconds),
    services: [
      SimulatedService(
        uuid: 'F000AA00-0001-4000-B000-000000000000',
        isAdvertised: true,
        characteristics: [
          SimulatedCharacteristic(
              uuid: 'F000AA10-0001-4000-B000-000000000000',
              value: Uint8List.fromList([0]),
              convenienceName: 'Generic characteristic 1'),
        ],
        convenienceName: 'Generic service 1',
      ),
      SimulatedService(
        uuid: 'F000AA01-0001-4000-B000-000000000000',
        isAdvertised: true,
        characteristics: [
          SimulatedCharacteristic(
              uuid: 'F000AA11-0001-4000-B000-000000000000',
              value: Uint8List.fromList([0]),
              convenienceName: 'Generic characteristic 2'),
        ],
        convenienceName: 'Generic service 2',
      ),
      SimulatedService(
        uuid: 'F000AA02-0001-4000-B000-000000000000',
        isAdvertised: true,
        characteristics: [
          SimulatedCharacteristic(
              uuid: 'F000AA12-0001-4000-B000-000000000000',
              value: Uint8List.fromList([0]),
              convenienceName: 'Generic characteristic 3'),
        ],
        convenienceName: 'Generic service 3',
      ),
      SimulatedService(
        uuid: 'F000AA03-0001-4000-B000-000000000000',
        isAdvertised: true,
        characteristics: [
          SimulatedCharacteristic(
              uuid: 'F000AA13-0001-4000-B000-000000000000',
              value: Uint8List.fromList([0]),
              convenienceName: 'Generic characteristic 4'),
        ],
        convenienceName: 'Generic service 4',
      ),
    ],
  );

  @override
  Future<bool> onConnectRequest() async {
    await Future.delayed(Duration(milliseconds: 500));
    return super.onConnectRequest();
  }

  @override
  Future<void> onDiscoveryRequest() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return super.onDiscoveryRequest();
  }
}
class ExampleCharacteristic extends SimulatedCharacteristic {
  ExampleCharacteristic({required String uuid, required String convenienceName})
      : super(
      uuid: uuid,
      value: Uint8List.fromList([0]),
      convenienceName: convenienceName);

  @override
  Future<void> write(Uint8List value, { bool sendNotification = true }) {
    int valueAsInt = value[0];
    if (valueAsInt != 0 && valueAsInt != 1) {
      return Future.error(SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed, "Unsupported value"));
    } else {
      return super.write(value); //this propagates value through the blemulator,
      // allowing you to react to changes done to this characteristic
    }
  }
}

class Info {
  Blemulator blemulator = Blemulator();
  blelib.BleManager bleManager = blelib.BleManager();
  Info() {
    blemulator.addSimulatedPeripheral(GenericPeripheral());
    blemulator.simulate();

    bleManager.createClient(); //this creates an instance of native BLE
  }
  bool get isAdvertising {
    return true;
  }
}
