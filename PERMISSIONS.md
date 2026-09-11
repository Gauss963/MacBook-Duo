# Screen Recording Permissions

During local development with ad-hoc signing, rebuilding the application creates a new code signature identity. To clean up mismatched authorizations from previous ad-hoc builds, each build runs the following command once upon its first launch for the current user:

`/usr/bin/tccutil reset ScreenCapture studio.prototype.HingeGlass.Global`

This command only resets screen capture permissions for this specific application identifier; it does not affect any other applications, other system permissions, or stored hinge angle calibrations. Upon success, the unique hash of the current code signature is stored so subsequent launches of the same build will not trigger another reset.

Resetting permissions does not grant authorization automatically. When enabling real-time desktop mode, macOS prompts the user to grant Screen Recording permissions, which may require quitting and reopening the app. This mechanism facilitates rapid iteration during development. Production builds should use a stable Developer ID certificate.

