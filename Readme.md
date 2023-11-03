# PortfolioKit

A SPM package to share your portfolio in your app dynamically.

## Installation

The preferred way of installing PortfolioKit is via the [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, open your project and navigate to **File** → **Add Package Dependencies...**
2. Paste the repository URL (`https://github.com/Mcrich23/PortfolioKit`) and click **Next**.
3. Click **Add Package**.
4. Click **Add Package** again.


## Configuration
To configure PortfolioKit, run `PortfolioKit.shared.config(with: url)` where url is the url to your json file.

*Note:*
Json files must follow this example:
```
[
    {
        "name": "Safari",
        "icon_url""https://is1-ssl.mzstat   .com/image/thumb/Purple126/v4/f8/76/09/f876095c-4f99-f138-d380-0420e21c3c89/AppIcon-0-0-1x_U007emarketing-0-0-10-0-0    -sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/540x540bb.jpg",
        "url": "https://apps.apple.com/us/app/safari/id1146562112",
        "url_button_name": "Get",
        "bundle_id": "com.apple.mobilesafari"
    }
]
```

## Usage

There are two methods of presenting data:

### Method 1
You can present the SwiftUi view `PortfolioView`, which will automatically show your configured data.

*Note:*
You can use the `.title(_:)` modifier to add a navigation view and title to the view.

### Method 2

You can access the raw data at `PortfolioKit.shared.portfolios`.
