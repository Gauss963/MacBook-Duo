# MacBook Duo

MacBook Duo brings depth and perspective to your MacBook display as you open and close the lid. Using the built-in lid angle sensor and Metal shaders, display contents appear anchored in 3D physical space, transitioning smoothly with realistic perspective projection and frosted glass depth-of-field effects.

## Features

- **Perspective Glass Effect**: Treats your desktop as a plane fixed in physical space. As the MacBook screen tilts along the bottom hinge, Metal calculates ray intersections per pixel and applies a graduated frosted blur.
- **Real-Time Desktop Mode**: Uses ScreenCaptureKit to stream and project the active desktop in real time onto an unobtrusive, non-activating overlay.
- **Screenshot Preview Mode**: Import any high-resolution desktop screenshot to inspect and tweak perspective dynamics without enabling live screen capture.
- **Hardware Lid Angle Sensor**: Reads real-time MacBook lid hinge angles via undocumented HID sensor channels at 30Hz with GPU time-smoothing.
- **Manual Simulation Fallback**: Adjustable slider simulation available for unsupported Macs or desk setups.
- **Zero Third-Party Dependencies**: Native Swift and Metal implementation compiled directly with Command Line Tools or Xcode.

## Usage

1. Open `MacBook Duo.app`.
2. **Screenshot Mode**:
   - Click **Import Screenshot** (take one with `⇧⌘3`).
   - Click **Start Setup**.
   - Tilt your MacBook display forward 15–35° to observe the perspective tilt and depth-of-field blur.
   - Adjust **Depth**, **Frost**, or toggle **Compare Original (`⌘B`)**.
   - Open the lid to your comfortable daily viewing angle and press `⌘K` or click **Save Endpoint**. The effect smoothly blends from 0° to your calibrated angle.
3. **Real-Time Desktop Mode**:
   - Click **Enable Real-Time Desktop Effect** (or press `⌘⇧G`).
   - Grant Screen Recording permission in **System Settings → Privacy & Security → Screen Recording** when prompted.
   - Use `⌘⇧Esc` anytime to halt real-time mode and return to the settings panel.

## Keyboard Shortcuts

### Global Shortcuts (System-wide)
- `⌘⇧G`: Toggle real-time global desktop effect.
- `⌘⇧K`: Save current physical lid angle as unfolded endpoint.
- `⌘⇧Esc`: Emergency stop — removes overlay immediately and reopens settings.

### In-App Shortcuts (Preview Page)
- `⌘H`: Toggle control overlay visibility.
- `Esc`: Restore control overlay.
- `⌘K`: Save current angle as endpoint.
- `⌘B`: Toggle comparison with original image.
- `⌘Q`: Quit application.

## Menu Bar Controls

MacBook Duo adds an icon to your macOS menu bar for quick access:
- Live lid angle and captured frame counter
- **Preview Real-Time Effect (8s)** (test rendering without moving the lid)
- **Toggle Global Effect** (`⌘⇧G`)
- **Save Current Angle as Endpoint** (`⌘⇧K`)
- **Open Settings** (`⌘⇧Esc`)
- **Quit**

## System Requirements

- **Operating System**: macOS 15.0+ (macOS 14.0+ minimum deployment).
- **Hardware**: Apple Silicon MacBook with built-in lid angle sensor.
- **Permissions**: Screen Recording permission required for real-time desktop mode. All processing is 100% local; no recordings are saved or transmitted.

## Building from Source

Ensure Apple Command Line Tools or Xcode is installed (`xcode-select --install`):

```sh
./build.sh
open "MacBook Duo.app"
```

The build script compiles all Swift sources with `swiftc`, embeds runtime Metal shaders, copies icons and metadata, and applies an ad-hoc local code signature.

## References & Inspiration

- Video demo reference: [Weibo](https://weibo.com/2/detail/5341559961948752)
- Projection model inspiration: [Atomicx7/Duo-animation](https://github.com/Atomicx7/Duo-animation)
- Swift prototype: [elijah-semyonov/DuoLikeAnimation](https://github.com/elijah-semyonov/DuoLikeAnimation)
- Lid HID sensor reading: [samhenrigold/LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor)
