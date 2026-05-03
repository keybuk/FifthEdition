# FifthEdition
![Build Status](https://img.shields.io/github/actions/workflow/status/keybuk/FifthEdition/swift.yml)

Swift support for 5eTools schema

## Adding FifthEdition as a Dependency

### Xcode

In Xcode, add FifthEdition with: `File` → `Add Package Dependencies…` and input the package URL:

https://github.com/keybuk/FifthEdition

### SwiftPM

To use the `FifthEdition` library in a SwiftPM project,
add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/keybuk/FifthEdition", from: "0.0.0"),
```

Include `"FifthEdition"` as a dependency for your executable target:

```swift
.target(name: "<target>", dependencies: [
    "FifthEdition",
]),
```

### Usage

Add `import FifthEdition` to your source code.

## Documentation

[API Documentation](https://keybuk.github.io/FifthEdition/documentation/fifthedition/).
