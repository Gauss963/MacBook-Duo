import Foundation
import Security

/// Development-build migration, not an authorization bypass. Never reset other apps.
enum ScreenCapturePermissionPreparation {
    static let bundleID = "studio.prototype.HingeGlass.Global"
    static let markerKey = "screenCapture.preparedCodeIdentity.v1"

    static func needsReset(identity: String, defaults: UserDefaults) -> Bool {
        defaults.string(forKey: markerKey) != identity
    }

    static func recordSuccess(identity: String, defaults: UserDefaults) {
        defaults.set(identity, forKey: markerKey)
    }

    static func codeIdentity() -> String? {
        var code: SecCode?
        guard SecCodeCopySelf([], &code) == errSecSuccess, let code else { return nil }
        var staticCode: SecStaticCode?
        guard SecCodeCopyStaticCode(code, [], &staticCode) == errSecSuccess,
              let staticCode else { return nil }
        var information: CFDictionary?
        guard SecCodeCopySigningInformation(staticCode, [], &information) == errSecSuccess,
              let values = information as? [String: Any],
              let hash = values[kSecCodeInfoUnique as String] as? Data,
              !hash.isEmpty else { return nil }
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    static func prepare() async -> String? {
        guard Bundle.main.bundleIdentifier == bundleID, let identity = codeIdentity() else {
            return "Unable to verify application signature; permissions were not automatically reset. Please reset Screen Recording permission manually if needed."
        }
        guard needsReset(identity: identity, defaults: .standard) else { return nil }
        let succeeded: Bool = await withCheckedContinuation { continuation in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/tccutil")
            process.arguments = ["reset", "ScreenCapture", bundleID]
            process.standardOutput = FileHandle.nullDevice
            process.standardError = FileHandle.nullDevice
            process.terminationHandler = { process in
                continuation.resume(returning: process.terminationStatus == 0)
            }
            do { try process.run() }
            catch { continuation.resume(returning: false) }
        }
        guard succeeded else {
            return "Permission reset failed. Please quit and reopen the app, or manually reset permissions."
        }
        recordSuccess(identity: identity, defaults: .standard)
        return "Completed first-launch permission reset for this build. When enabling real-time desktop effect, please grant Screen Recording permission when prompted."
    }
}
