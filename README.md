Mith VAULT SDK for iOS
========================

This open-source library allows you to integrate VAULT into your app.
Learn more about about the provided samples, documentation, integrating the SDK into your app, and more at [deck slide](https://drive.google.com/file/d/1wjHUySvL6YMUFf3HkHrWVASJEipdooOo/view?usp=sharing)

FEATURE
--------
* [login](https://documenter.getpostman.com/view/4856913/RztrHRU9#3563f4ea-88bc-403d-8071-d3d3767bd01d)
* [mining](https://documenter.getpostman.com/view/4856913/RztrHRU9#0cbb0a41-2cfc-4d3a-b541-4cfbbf807843)
* [donate](https://documenter.getpostman.com/view/4856913/RztrHRU9#608ccdd4-6a95-41f0-b247-ffae9a976feb)

INSTALLATION
------------
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate MithVaultSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'MithVaultSDK'
```

Then, run the following command:

```bash
$ pod install
```

USAGE
------------
Configure the Info.plist file with an XML snippet that contains client ID, client secret, and minging key of your team.
```XML
<key>ClientId</key>
<string>[client ID]</string>
<key>ClientSecret</key>
<string>[client secret]</string>
<key>MiningKey</key>
<string>[minging key]</string>
```

If the deployment target of your app below iOS 11, also add the following to your Info.plist file
```XML
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>vault-[client ID]</string>
        </array>
    </dict>
</array>
```

If the deployment target of your app below iOS 11, add the following to your AppDelegate class.
### Swift
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return MithVaultSDK.shared.open(url: url)
}
```

### Objective-C
```objc
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[MithVaultSDK shared] openWithUrl: url];
}
```

GIVE FEEDBACK
-------------
Please report bugs or issues to [hackathon@mith.io](hackathon@mith.io)