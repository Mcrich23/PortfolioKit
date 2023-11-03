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
    "name": "Pickt",
    "icon_url":"https://static.wixstatic.com/media/193764_6b21a958b29a4b4db9daacb1406e71a8~m.png/v1/fill/w_382,h_382,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/pickt.png",
    "url": "https://apps.apple.com/us/app/pickt/id1584491007",
    "url_button_name": "Get"
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
