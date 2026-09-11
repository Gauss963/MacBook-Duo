# MacBook Duo — Source Overview

This package contains the complete implementation for MacBook Duo, including screenshot preview and real-time desktop modes, app icons, build scripts, permission test suites, and documentation.

## Building

Install Apple Command Line Tools or Xcode (`xcode-select --install`), then execute:

```sh
./build.sh
open "MacBook Duo.app"
```

The build script invokes the system Swift compiler (`swiftc`) to produce a native Apple Silicon arm64 application with ad-hoc code signing. No third-party dependencies are required. Metal shader sources are embedded within Swift and compiled at runtime.

The minimum deployment target is macOS 15.0 on Apple Silicon Macs.

## Source Code Structure

- `Sources/HingeGlassApp.swift`: Application entry point, window lifecycle, menu bar items, and shortcuts.
- `Sources/RootView.swift`: Welcome page, setup flow, and debug controls.
- `Sources/AppModel.swift`: Screenshot management, calibration parameters, and app state.
- `Sources/GlassRenderer.swift`: Metal shaders, vertex projection, and depth-of-field glass rendering.
- `Sources/LidAngleSensor.swift`: Hardware hinge angle sensor HID driver.
- `Sources/GlobalDesktopController.swift`: ScreenCaptureKit desktop streaming, full-screen overlay panel, and sleep/wake recovery logic.
- `Sources/ScreenCapturePermissionPreparation.swift`: Development-build TCC permission preparation.
- `Tests/`: Permission logic and state persistence tests.
- `Assets/`: Application icons and icon generation prompt.
- `Info.plist`, `build.sh`: App metadata and build script.

## Notes

Real-time desktop mode requires macOS Screen Recording permissions and a compatible MacBook lid angle sensor. The development build resets its screen recording entry on first run per code signature hash to ensure clean authorization states. Avoid running multiple instances with the same bundle identifier simultaneously.

