// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.example.platformchannel;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.widget.Toast;

import java.util.HashMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String BATTERY_CHANNEL = "samples.flutter.io/battery";
  private static final String CHARGING_CHANNEL = "samples.flutter.io/charging";

  private static final String INTENT_CHANNEL = "samples.flutter.io/intent";


  private MethodChannel mMethodIntentChannel;

  private StreamHandler mStreamHandler;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

      mStreamHandler = new StreamHandler() {
        private BroadcastReceiver chargingStateChangeReceiver;
        @Override
        public void onListen(Object arguments, EventSink events) {
            chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
            registerReceiver(
                    chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        }

        @Override
        public void onCancel(Object arguments) {
            unregisterReceiver(chargingStateChangeReceiver);
            chargingStateChangeReceiver = null;
        }
    };

      new EventChannel(getFlutterView(), CHARGING_CHANNEL).setStreamHandler(mStreamHandler);

      mMethodIntentChannel = new MethodChannel(getFlutterView(), INTENT_CHANNEL);
      mMethodIntentChannel.setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall methodCall, Result result) {
                    if ("openPage".equals(methodCall.method)) {
                        Intent intent = new Intent(MainActivity.this, SecondActivity.class);
                        if (methodCall.arguments instanceof HashMap) {
                            TransData data = new TransData();
                            data.fromMap((HashMap) methodCall.arguments);
                            intent.putExtra("data", data);
                        }
                        MainActivity.this.startActivityForResult(intent, 100);
                    }
                }
            }
    );

    new MethodChannel(getFlutterView(), BATTERY_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Result result) {
            if (call.method.equals("getBatteryLevel")) {
              int batteryLevel = getBatteryLevel();

              if (batteryLevel != -1) {
                result.success(batteryLevel);
              } else {
                result.error("UNAVAILABLE", "Battery level not available.", null);
              }
            } else {
              result.notImplemented();
            }
          }
        }
    );
  }

    protected void onDestroy() {
        super.onDestroy();
        if (null != mStreamHandler) {
            mStreamHandler.onCancel(null);
        }

    }


    private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
          events.error("UNAVAILABLE", "Charging status unavailable", null);
        } else {
          boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                               status == BatteryManager.BATTERY_STATUS_FULL;
          events.success(isCharging ? "charging" : "discharging");
        }
      }
    };
  }

  private int getBatteryLevel() {
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
  }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        TransData transData = intent.getParcelableExtra("data");
        if (null != transData) {
            mMethodIntentChannel.invokeMethod("onResult", transData.toMap(),
                    new MethodChannel.Result() {

                        @Override
                        public void success(Object o) {
                            Toast.makeText(MainActivity.this, "native invoke flutter success",
                                    Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void error(String s, String s1, Object o) {
                            Toast.makeText(MainActivity.this, "native invoke flutter " + s + " " + s1,
                                    Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void notImplemented() {
                            Toast.makeText(MainActivity.this, "native invoke flutter not implemented",
                                    Toast.LENGTH_SHORT).show();
                        }
                    });
        }

    }

    //    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (requestCode == 100 && RESULT_OK == resultCode) {
//            // 自定义消息机制
////            new BasicMessageChannel<TransData>().setMessageHandler(
////                    new BasicMessageChannel.MessageHandler<TransData>() {
////                        @Override
////                        public void onMessage(TransData transData, BasicMessageChannel.Reply<TransData> reply) {
////
////                        }
////                    }
////            );
//
//            // singleTop resultCode 0 = RESULT_CANCELED
//
//            TransData transData = data.getParcelableExtra("data");
//            if (null != transData) {
//                mMethodIntentChannel.invokeMethod("onResult", transData.toMap());
//            }
//        }
//    }
}
