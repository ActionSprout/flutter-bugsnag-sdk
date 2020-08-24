import Bugsnag
import Flutter
import UIKit

public class SwiftSnagbugPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "actionsprout.com/snagbug", binaryMessenger: registrar.messenger())
        let instance = SwiftSnagbugPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            result(FlutterError(
                code: "INVALID_ARGS",
                message: "Arguments must be a Map<String, dynamic>",
                details: nil
            ))
            return
        }

        switch call.method {
        case "send_error":
            sendError(arguments, result)
        default:
            result(FlutterError(
                code: "UNIMPLEMENTED",
                message: "Method \(call.method) not implemented",
                details: nil
            ))
        }
    }

    public func application(_: UIApplication, didFinishLaunchingWithOptions _: [AnyHashable: Any]) -> Bool {
        startBugsnag()
        return true
    }

    public func application(_: UIApplication, open _: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        startBugsnag()
        return true
    }

    private func startBugsnag() {
        let config = BugsnagConfiguration.loadConfig()
        // config.appVersion = "..."

        Bugsnag.start(with: config)
    }

    private func sendError(_ args: [String: Any?], _ result: @escaping FlutterResult) {
        guard let errorClass = args["type"] as? String, let errorMessage = args["message"] as? String, let frames = args["stack"] as? [[String: Any]] else {
            result(FlutterError(
                code: "INVALID_ARG",
                message: "Method 'send_error' received invalid arguments.",
                details: nil
            ))
            return
        }

        Bugsnag.notify(createCanaryError()) { event in
            event.errors[0].errorClass = errorClass
            event.errors[0].errorMessage = errorMessage
            event.errors[0].stacktrace = frames.map { (frame) -> BugsnagStackframe in
                let translated = BugsnagStackframe()
                translated.machoFile = frame["file"] as! String
                translated.method = frame["member"] as! String
                return translated
            }

            return true
        }
        result(nil)
    }

    // The initial error we use is thrown away, so it's a "canary".
    private func createCanaryError() -> NSException {
        NSException(
            name: NSExceptionName(rawValue: "SnagbugException"),
            reason: "Canary",
            userInfo: nil
        )
    }
}
