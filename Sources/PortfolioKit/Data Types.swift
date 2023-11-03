//
//  Data Types.swift
//  
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation
import UIKit

struct PortfolioResponse: Codable {
    let name: String
    let iconUrl: String
    let url: String
    let urlButtonName: String
}

public struct Portfolio: Identifiable {
    public let id = UUID()
    public let name: String
    public let image: UIImage
    public let url: URL
    public let urlButtonName: String
}
