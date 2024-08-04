package com.example.steal_client

import android.content.Context
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter
import android.net.VpnService
import android.os.Bundle
import android.os.Build
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat




import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.FlutterInjector


class MainActivity: FlutterActivity(){
    private val CHANNEL = "StealVPN"
    private val VPN_REQUEST_CODE = 24
    private val REQUEST_CODE_POST_NOTIFICATIONS = 1

    private var pendingResult: MethodChannel.Result? = null

    private val vpnReadyReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == StealVpnService.ACTION_VPN_READY) {
                pendingResult?.success(VPN_INTERFACE!!.fd.toString())
                pendingResult = null
                unregisterReceiver(this)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestPermission" -> {
                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        pendingResult = result
                        startActivityForResult(intent, VPN_REQUEST_CODE)
                    } else {
                        result.success(true)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_CODE_POST_NOTIFICATIONS)
                        }
                    }
                }


                "isActive" -> {
                    if (VPN_INTERFACE != null) {
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                "getFd" -> {
                    pendingResult = result
                    val filter = IntentFilter(StealVpnService.ACTION_VPN_READY)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        registerReceiver(vpnReadyReceiver, filter, RECEIVER_EXPORTED)
                   }else {
                        registerReceiver(vpnReadyReceiver, filter)
                   }
                   


                    val startIntent = Intent(this, StealVpnService::class.java)

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(startIntent)
                    } else {
                        startService(startIntent)
                    }

                }

                "startSteal" -> {
                    val config = call.argument<String?>("config") ?: "default"
                    startSteal(config)
                    result.success(true)
                }

                "stop" -> {
                    val stopIntent = Intent(this, StealVpnService::class.java).apply {
                        action = StealVpnService.ACTION_STOP_SERVICE
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(stopIntent)
                    } else {
                        startService(stopIntent)
                    }
                    result.success(true)
                    }

                "ping" -> {
                    runBlocking {
                        val duration = async { ping() }.await()
                        result.success(duration)
                    }
                    }
                }
            }
        }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_REQUEST_CODE) {
            pendingResult?.let {
                if (resultCode == RESULT_OK) {
                    it.success(true)
                } else {
                    it.success(false)
                }
            }
            pendingResult = null
        }
    }
}
