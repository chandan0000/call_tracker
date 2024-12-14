package com.example.call_tracker

import android.content.Intent
import android.os.Bundle
import android.telecom.TelecomManager
import android.telephony.TelephonyManager
import android.content.Context
import android.content.BroadcastReceiver
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.call_r/call_handler"
    private lateinit var channel: MethodChannel
    private var callReceiver: CallReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "acceptCall" -> {
                    try {
                        acceptIncomingCall()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ACCEPT_ERROR", e.message, null)
                    }
                }
                "declineCall" -> {
                    try {
                        declineIncomingCall()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("DECLINE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestPermissions()
        registerCallReceiver()
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterCallReceiver()
    }

    private fun requestPermissions() {
        val permissions = arrayOf(
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ANSWER_PHONE_CALLS,
            Manifest.permission.READ_CALL_LOG
        )

        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }.toTypedArray()

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissionsToRequest, 100)
        }
    }

    private fun acceptIncomingCall() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ANSWER_PHONE_CALLS) 
            == PackageManager.PERMISSION_GRANTED) {
            val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
            telecomManager.acceptRingingCall()
        }
    }

    private fun declineIncomingCall() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ANSWER_PHONE_CALLS) 
            == PackageManager.PERMISSION_GRANTED) {
            val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
            telecomManager.endCall()
        }
    }

    private fun registerCallReceiver() {
        callReceiver = CallReceiver()
        val filter = IntentFilter().apply {
            addAction(TelephonyManager.ACTION_PHONE_STATE_CHANGED)
        }
        registerReceiver(callReceiver, filter)
    }

    private fun unregisterCallReceiver() {
        callReceiver?.let {
            unregisterReceiver(it)
            callReceiver = null
        }
    }

    inner class CallReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
                val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
                val number = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)

                when (state) {
                    TelephonyManager.EXTRA_STATE_RINGING -> {
                        number?.let {
                            runOnUiThread {
                                channel.invokeMethod("onIncomingCall", 
                                    mapOf("phoneNumber" to it))
                            }
                        }
                    }
                }
            }
        }
    }
}