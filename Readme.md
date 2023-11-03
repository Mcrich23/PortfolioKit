# PackageKit

A SPM package to get all the information about other SPM packages.

## Installation

The preferred way of installing PackageKit is via the [Swift Package Manager](https://swift.org/package-manager/).

1. In Xcode, open your project and navigate to **File** → **Add Package Dependencies...**
2. Paste the repository URL (`https://github.com/Mcrich23/PackageKit`) and click **Next**.
3. Click **Add Package**.
4. Click **Add Package** again.

## Usage
**Disclaimer**: You must copy `Package.resolved` to the app or specify the path otherwise to use PackageKit.

### Getting the packages in your project

Run `PackageKit.getPackages()`

#### Example:
```
import SwiftUI
import PackageKit

struct ContentView: View {
    var body: some View {
        Text("Hello World!")
            .onAppear {
                let packages = PackageKit.getPackages()
                print(packages)
            }
    }
}
```
## Limitations
Right now, PackageKit only supports Github Swift Packages, but more git hosting software support is in the near future.
