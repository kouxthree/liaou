package com.liaou;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.Context;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;


public class BlBase extends FlutterActivity {
    private static final String CHANNEL = "com.liaou.bl";
    private BluetoothManager blManager = null;
    private BluetoothAdapter blAdapter = null;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // this method is invoked on the main thread.
                            switch (call.method) {
                                case "supportBluetooth":
                                    if(supportBluetooth()) {
                                        openBluetooth();
                                        result.success("Bluetooth Opened");
                                    } else {
                                        result.error("Bluetooth Not Supported", null, null);
                                    }
                                    break;
                                case "getBluetooth":
                                    if(disabled()){
                                        result.success("Bluetooth Already Opened");
                                    }else{
                                        result.success("Bluetooth Not Opened");
                                    }
                                    break;
                                default:
                                    result.error("Channel Unknown", null, null);
                                    break;
                            }
                        }
                );
    }

    //is bluetooth supported
    private boolean supportBluetooth() {
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            blManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
            blAdapter = blManager.getAdapter();
        }
        if (blAdapter == null) {//bluetooth not supported
            return false;
        }
        return true;
    }

    //open bluetooth
    private void openBluetooth() {
        Intent enable = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
        startActivityForResult(enable, 1);
    }

    //is bluetooth disabled
    private boolean disabled() {
        if (blAdapter.isEnabled()) {
            return true;
        }
        return false;
    }
}
