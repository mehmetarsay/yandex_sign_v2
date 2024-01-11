package com.mehmetarsay.yandex_sign

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Base64
import android.util.Log
import androidx.annotation.RequiresApi
import java.net.URLEncoder
import java.security.spec.PKCS8EncodedKeySpec
import java.security.KeyFactory
import java.security.Signature
import java.security.NoSuchAlgorithmException
import java.security.InvalidKeyException
import java.io.UnsupportedEncodingException

class YandexSignPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "yandex_sign")
        channel.setMethodCallHandler(this)
    }

    @RequiresApi(Build.VERSION_CODES.FROYO)
    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getSignUrl") {
            result.success(getSignUrl(call.arguments))
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    @RequiresApi(Build.VERSION_CODES.FROYO)
    private fun getSignUrl(arguments: Any?): String {
        if (arguments !is Map<*, *>) {
            throw IllegalArgumentException("Invalid arguments: expected a Map")
        }

        val url = arguments["url"] as String
        val key = arguments["key"] as String
        val data = sha256rsa(key, url)

        return data
    }

    @RequiresApi(Build.VERSION_CODES.FROYO)
    private fun sha256rsa(key: String, data: String): String {
        val trimmedKey = key.replace("-----BEGIN RSA PRIVATE KEY-----", "")
            .replace("-----END RSA PRIVATE KEY-----", "")
            .replace("\\s".toRegex(), "")
        Log.d("KOTLIN", trimmedKey)

        return try {
            val decodedKey = Base64.decode(trimmedKey, Base64.DEFAULT)
            val keyFactory = KeyFactory.getInstance("RSA")
            val keySpec = PKCS8EncodedKeySpec(decodedKey)
            val privateKey = keyFactory.generatePrivate(keySpec)
            val signature = Signature.getInstance("SHA256withRSA")
            signature.initSign(privateKey)
            signature.update(data.toByteArray())

            val encrypted = signature.sign()
            URLEncoder.encode(Base64.encodeToString(encrypted, Base64.NO_WRAP), "UTF-8")
        } catch (e: NoSuchAlgorithmException) {
            throw SecurityException("SHA256withRSA algorithm not found", e)
        } catch (e: InvalidKeyException) {
            throw SecurityException("Invalid RSA key", e)
        } catch (e: UnsupportedEncodingException) {
            throw SecurityException("UTF-8 encoding not supported", e)
        }
    }
}
