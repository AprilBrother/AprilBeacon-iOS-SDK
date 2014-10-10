
## Docs

* [Current documentation](//aprilbrother.github.io/aprilbeacon-ios-sdk/Documents/index.html)
* [Community for AprilBeacon](http://bbs.aprbrother.com)

## How to install

### From CocoaPods

Add the following line to your Podfile:

	pod ‘AprilSDK'


Then run the following command in the same directory as your Podfile:

	pod update


### Normal way

1. Copy the folder 'AprilSDK' to your project directory.
2. Add libAprilBeaconSDK.a to your Framework.
3. Add 'AprilSDK/Headers' (relative path to your project) to Header Search Paths in Build Settings of your target.

### iOS 8 

If your app supports iOS 8, you should add NSLocationAlwaysUsageDescription key with message to be displayed in the prompt to Info.plist.


## Changelog

To see what has changed in recent versions of April SDK, see the [CHANGELOG](https://github.com/AprilBrother/AprilBeacon-iOS-SDK/blob/master/CHANGELOG.md).