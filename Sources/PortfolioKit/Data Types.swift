//
//  Data Types.swift
//  
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

import StoreKit

#if canImport(UIKit)
    public typealias PortfolioImage = UIImage
#endif

#if canImport(AppKit)
    public typealias PortfolioImage = NSImage
#endif

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
    
    var storekitProduct: SKStoreProductViewController?
    
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
