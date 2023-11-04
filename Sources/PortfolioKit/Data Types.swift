//
//  Data Types.swift
//  
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation
import UIKit
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
    public let image: UIImage
    public let url: URL
    public let urlButtonName: String
    public let bundleID: String?
    
    var storekitProduct: SKStoreProductViewController?
    
    public var appStoreId: String? {
        guard urlIsAppStore() else { return nil }
        
        return self.url.lastPathComponent.replacingOccurrences(of: "id", with: "")
    }
    
    public func urlIsAppStore() -> Bool {
        if #available(iOS 16, *) {
            if url.host() == "apps.apple.com" {
                return true
            } else {
                return false
            }
        } else {
            if url.host == "apps.apple.com" {
                return true
            } else {
                return false
            }
        }
    }
}
