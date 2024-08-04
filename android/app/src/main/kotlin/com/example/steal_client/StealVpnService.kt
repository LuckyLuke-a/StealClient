package com.example.steal_client

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import okhttp3.OkHttpClient
import okhttp3.Request
import java.net.InetSocketAddress
import java.net.Proxy
import kotlinx.coroutines.withContext
import engine.StealEngine

val IO_SCOPE = CoroutineScope(Dispatchers.IO)
val App_Engine = StealEngine()
var VPN_INTERFACE: ParcelFileDescriptor? = null

class StealVpnService : VpnService() {
    companion object {
        private const val CHANNEL_ID = "StealClient"
        private const val NOTIFICATION_ID = 1
        const val ACTION_STOP_SERVICE = "STOP_SERVICE"
        const val ACTION_VPN_READY = "VPN_READY"
    }

    override fun onCreate() {
        super.onCreate()
        if (canSendNotification()) {
            createNotificationChannel()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_SERVICE) {
            stopService()
            return START_NOT_STICKY
        }

        val builder = Builder()
            .addAddress("26.26.26.4", 32)
            .addRoute("0.0.0.0", 0)
            .addDnsServer("1.1.1.1")
            .setMtu(1500)
            .addRoute("::", 0)
            .addDisallowedApplication(this.packageName)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            builder.setMetered(false)
        }
        VPN_INTERFACE = builder.establish()!!

        val broadcastIntent = Intent(ACTION_VPN_READY)
        sendBroadcast(broadcastIntent)

        if (canSendNotification()) {
            startForeground(NOTIFICATION_ID, createNotification())
        }
        return START_STICKY
    }

    override fun onRevoke() {
        super.onRevoke()
        stopService()
    }

    private fun stopService() {
        App_Engine.stop()
        VPN_INTERFACE?.close()
        VPN_INTERFACE = null
        stopForeground(true)
        stopSelf()
    }

    private fun canSendNotification(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Steal Client",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun createNotification(): Notification {
        val stopIntent = Intent(this, StealVpnService::class.java).apply {
            action = ACTION_STOP_SERVICE
        }

        val stopPendingIntent: PendingIntent = PendingIntent.getService(
            this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Steal Client")
            .setSmallIcon(R.drawable.ic_key)
            .addAction(
                R.drawable.ic_key,
                "Stop",
                stopPendingIntent
            )
            .setOngoing(true)
            .setSilent(true)
            .build()
    }
}

fun startSteal(configData: String) {
    App_Engine.configData = configData
    App_Engine.start()
}

suspend fun ping(): Int {
    val proxyAddress = InetSocketAddress("127.0.0.1", 8091)
    val proxy = Proxy(Proxy.Type.HTTP, proxyAddress)
    val builder = OkHttpClient.Builder()
    builder.proxy(proxy)
    val client = builder.build()

    val request = Request.Builder()
        .url("https://www.gstatic.com/generate_204")
        .head()
        .build()

    var duration = -1
    try {
        val startTime = System.currentTimeMillis()
        withContext(Dispatchers.IO) {
            client.newCall(request).execute()
        }
        val endTime = System.currentTimeMillis()
        duration = (endTime - startTime).toInt()
    } catch (e: Exception) {
        e.printStackTrace()
    }
    return duration
}
