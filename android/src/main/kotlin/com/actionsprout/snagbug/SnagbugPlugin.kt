package com.actionsprout.snagbug

import androidx.annotation.NonNull;

import com.bugsnag.android.Bugsnag

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** SnagbugPlugin */
public class SnagbugPlugin : ActivityAware, FlutterPlugin, MethodCallHandler {
    override fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
        Bugsnag.start(binding.getActivity())
    }

    override fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {
        Bugsnag.start(binding.getActivity())
    }

    override fun onDetachedFromActivity() {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "actionsprout.com/snagbug")
        channel.setMethodCallHandler(this)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "actionsprout.com/snagbug")
            channel.setMethodCallHandler(SnagbugPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.arguments !is HashMap<*, *>) {
            result.error("INVALID_ARGS", "Arguments must be a Map<String, dynamic>", null)
            return
        }

        val args = call.arguments as HashMap<String, Any>

        when {
            call.method == "send_error" -> sendError(args, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun sendError(@NonNull args: HashMap<String, Any>, @NonNull result: Result) {
        if (args["type"] !is String || args["message"] !is String || args["stack"] !is ArrayList<*>) {
            result.error(
                    "INVALID_ARG",
                    "Method 'send_error' received invalid arguments.",
                    null
            )
            return
        }

        Bugsnag.notify(FromDartThrowable(
                args["type"] as String,
                args["message"] as String,
                args["stack"] as ArrayList<*>
        ))

        result.success(null)
    }
}
