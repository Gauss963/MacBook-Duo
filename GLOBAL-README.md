# MacBook Duo — Real-Time Global Desktop Mode

## Overview

The global mode presents a full-screen, non-activating `NSPanel` configured with `canJoinAllApplications`, `canJoinAllSpaces`, and `fullScreenAuxiliary`. Its window level is positioned above standard applications to cover native full-screen spaces, the Dock, and the menu bar, preventing visual duplication while passing mouse clicks and keyboard events through to underlying apps. Emergency exit is always available via `⌘⇧Esc`.

## Getting Started

1. Launch `MacBook Duo.app` and click **Enable Real-Time Desktop Effect** (or press `⌘⇧G`).
2. On first launch, macOS requires granting Screen Recording permissions under **System Settings → Privacy & Security → Screen Recording**. If macOS prompts you to quit and reopen, follow the prompt.
3. Once enabled, the perspective effect smoothly blends from 0° up to your calibrated endpoint. As you reach your normal viewing angle, the overlay is hidden and the native desktop is restored.

## Shortcuts

- `⌘⇧G`: Start / stop real-time global effect.
- `⌘⇧K`: Save current physical hinge angle as unfolded endpoint.
- `⌘⇧Esc`: Immediately stop and return to settings.
- The menu bar icon provides quick toggles, calibration, settings access, and quit.
- Preview test page shortcuts (`⌘H`, `⌘K`, `⌘B`) remain active when the preview window is focused.

## Technical Details

- **Supported Hardware**: Built-in MacBook displays on Apple Silicon. External monitors do not move with the lid hinge.
- **Local Capture**: ScreenCaptureKit streams the desktop at display resolution (30 fps) while excluding the application itself. Frames are processed entirely on GPU with Metal shaders. No video is ever saved to disk or transmitted over the network.
- **Overlay Behavior**: The overlay ignores mouse events and does not steal keyboard focus. Because visual elements under perspective tilt shift slightly from their flat coordinates, interact with desktop UI after opening past the calibrated endpoint.
- **Safety Fallbacks**: The overlay is automatically dismissed upon capture errors, 4 seconds of missing stream callbacks, 2 seconds without lid angle sensor updates, system sleep, or display configuration changes.
- **Sleep / Wake Lifecycle**: Window state and GPU resources are preserved across sleep and wake events, automatically resuming once the display is active and the sensor re-engages.

