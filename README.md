# snagbug

Flutter integration to first-party Bugsnag SDKs.

## Installation

To install, add the following to the `dependencies` section of your `pubspec.yaml` file:

```
snagbug: ^1.0.0
```

Then, ensure Flutter has installed it with `flutter pub get`.

## Configuration

Follow the Bugsnag documentation for each mobile platform supported:

- [iOS](https://docs.bugsnag.com/platforms/ios/#basic-configuration)
- [Android](https://docs.bugsnag.com/platforms/android/#basic-configuration)

## What's with the name?

Turns out, the Flutter tooling prevents a package from sharing a name with the underlying Cocoapod. Seriously.

Snagbug seemed like the least bad option.
