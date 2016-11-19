# i18nOTAClient
Over-the-air translation update for your iOS apps with your i18n Server

Please, not that this work is still in progress, any comments is more than welcome.

## How to

First, specify your baseUrl and a projectName.
exemple : 
```swift
i18n.shared.projectName = "myProject"
i18n.shared.baseUrl = "http://my.server.url/api"
```

Finally, on your server create GET and POST webservices who respect the following syntax :
URL :`{baseURl}/{language}/{myProject}`

GET response:
```json
{
"key":"value",
 ...
 "key":"value"
}
```

POST Body:
```json
{
"app": "myProject",
 "key": "someKey",
 "locale": "fr",
 "value": "localizedValue"
}
```
## How it works

i18nClient will download all the translation for the current language of your phone. 
Also, it will remplace automatically every text found in your storyboard and/or xib files.

you can use `localized(key: String) -> String` methods to get a translate for a specify key and the current language of your device.

If a key is not found, then i18nClient use the POST web service to send it to your server, then you just have to translate it for all language that you support.

## Install

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate i18nOTAClient into your Xcode project using CocoaPods, it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'i18nOTAClient', :git => 'https://github.com/favret/i18nOTAClient.git', :tag => '0.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```
