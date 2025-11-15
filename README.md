# GestaltHax

Hactivation via MobileGestalt POC.

Working for iOS 15 ~ 18.5.

For iOS 18.6 ~ 26.2b2, see the [updated gestalt exploit](https://github.com/hanakim3945/gestalt_hax_v2)

### Why is this working?
mobileactivationd skips the usual activation process on demoted devices, such as internal UI prototypes and other factory equipment.
By spoofing AP demotion in the CacheData bitmap in mobilegestalt cache, mobileactivationd recognizes the device as demoted and therefore shortcut the activation process :)

Happy hactivation!

### Todo
Binary need to run on target device to find the required offsets in CacheData. Just compile it for desired architecture and run it.
```
For iOS ~>

xcrun clang -target arm64-apple-ios15.0 -isysroot $(xcrun --sdk iphoneos --show-sdk-path) -mios-version-min=15.0 -objc -framework Foundation -o gestaltpatcher patcher.m
```

## Usage
Run the tool on iOS or macOS with path to mobilegestalt cache plist

```
./gestaltpatcher <path_to_mobilegestalt_plist>
```
