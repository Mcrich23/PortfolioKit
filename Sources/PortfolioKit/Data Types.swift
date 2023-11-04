//
//  Data Types.swift
//  
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation

#if canImport(TVUIKit)
import TVUIKit
public typealias PortfolioImage = UIImage
public typealias PortfolioVC = UIViewController
#endif

#if canImport(UIKit) && !os(tvOS)
import UIKit
public typealias PortfolioImage = UIImage
public typealias PortfolioVC = UIViewController
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias PortfolioImage = NSImage
public typealias PortfolioVC = NSViewController
#endif

import StoreKit

/// The raw response data from the portfolio json
struct PortfolioResponse: Codable {
    let name: String
    let iconUrl: String
    let url: String
    let urlButtonName: String
    let bundleId: String?
}

public struct Portfolio: Identifiable {
    public let id = UUID()
    public let name: String
    public let image: PortfolioImage
    public let url: URL
    public let urlButtonName: String
    public let bundleID: String?
    
    #if os(iOS)
    var storekitProduct: SKStoreProductViewController?
    #endif
    
    /// The app store element id if available
    public var appStoreId: String? {
        guard urlIsAppStore else { return nil }
        
        return self.url.lastPathComponent.replacingOccurrences(of: "id", with: "")
    }
    
    /// If the url is an app store app
    public var urlIsAppStore: Bool {
        let appStoreHost = "apps.apple.com"
        #if os(macOS)
        if #available(macOS 13, *) {
            return url.host() == appStoreHost
        } else {
            return url.host == appStoreHost
        }
        #elseif os(iOS)
        if #available(iOS 16, *) {
            return url.host() == appStoreHost
        } else {
            return url.host == appStoreHost
        }
        #else
        return url.host == appStoreHost
        #endif
    }
}
