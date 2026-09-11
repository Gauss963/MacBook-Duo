import SwiftUI
import AppKit
import UniformTypeIdentifiers

@MainActor
final class AppModel: ObservableObject {
    enum Page {
        case setup
        case test
    }

    @Published var page: Page = .setup
    @Published var desktopImage: NSImage?
    @Published var importedFileName = ""
    @Published var useSensor = true
    @Published var simulatedAngle = 105.0
    @Published var controlsHidden = false
    @Published var showOriginal = false
    @Published var calibrationMessage = ""
    @Published var openAngle = 120.0
    @Published var globalStatus = "Real-time desktop mode requires screen recording permission"
    @Published var globalRunning = false
    @Published var permissionsPreparing = true
    var startGlobal: (() -> Void)?
    var previewGlobal: (() -> Void)?

    var currentAngle: Double { useSensor && sensor.isAvailable ? sensor.angle : simulatedAngle }

    func saveOpenAngle() {
        let value = currentAngle
        guard value.isFinite, value >= 1, value <= 180 else {
            calibrationMessage = "Please open the display before saving the endpoint"
            controlsHidden = false
            return
        }
        openAngle = value
        UserDefaults.standard.set(value, forKey: "calibratedOpenAngle")
        calibrationMessage = "Endpoint saved"
    }

    let sensor = LidAngleSensor()

    init() {
        let saved = UserDefaults.standard.object(forKey: "calibratedOpenAngle") as? Double
            ?? UserDefaults(suiteName: "studio.prototype.HingeGlass")?.double(forKey: "calibratedOpenAngle") ?? 120
        if saved >= 1 && saved <= 180 { openAngle = saved }
        sensor.start()
    }

    func importScreenshot() {
        let panel = NSOpenPanel()
        panel.title = "Select Desktop Screenshot"
        panel.message = "Choose a full desktop screenshot to display beneath the glass layer."
        panel.prompt = "Import"
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.png, .jpeg, .heic, .tiff]

        guard panel.runModal() == .OK,
              let url = panel.url,
              let image = NSImage(contentsOf: url)
        else { return }

        desktopImage = image
        importedFileName = url.lastPathComponent
    }

    func startTest() {
        guard desktopImage != nil else { return }
        controlsHidden = false
        withAnimation(.spring(response: 0.55, dampingFraction: 0.86)) {
            page = .test
        }
    }

    func returnToSetup() {
        controlsHidden = false
        withAnimation(.easeInOut(duration: 0.3)) {
            page = .setup
        }
    }

    func toggleFullScreen() {
        guard let window = NSApp.keyWindow, let screen = window.screen else { return }
        window.setFrame(screen.frame, display: true)
    }
}
