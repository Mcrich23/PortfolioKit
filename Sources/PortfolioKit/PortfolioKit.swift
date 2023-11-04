// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftUI
import UIKit

public class PortfolioKit: ObservableObject {
    public static let shared = PortfolioKit()
    @Published public private(set) var portfolios: [Portfolio] = []
    
    func setPortfolios(_ portfolios: [Portfolio]) {
        for portfolio in portfolios {
            if let index = self.portfolios.firstIndex(where: { $0.id == portfolio.id }) {
                self.portfolios[index] = portfolio
            }
        }
    }
    
    /**
     Configure PortfolioKit and fetch all of your specified data.
     
     - parameter url: The url location for the json file to pull.
     - parameter showCurrentApp: Tell PortfolioKit if you want to show the current app that is displaying this information.
     
     
     # Notes: #
        Json files must follow this example:
     ```
     [
       {
         "name": "Safari",
         "icon_url": "https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/f8/76/09/f876095c-4f99-f138-d380-0420e21c3c89/AppIcon-0-0-1x_U007emarketing-0-0-0-10-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/540x540bb.jpg",
         "url": "https://apps.apple.com/us/app/safari/id1146562112",
         "url_button_name": "Get",
         "bundle_id": "com.apple.mobilesafari"
       }
     ]
     ```
     
     # Example #
     ```
     PortfolioKit.shared.config(with: url)
     ```
     
     */
    
    public func config(with url: URL, showCurrentApp: Bool = false) {
        Task {
            try await config(with: url, showCurrentApp: showCurrentApp)
        }
    }
    
    public func config(with url: URL, showCurrentApp: Bool = false) async throws {
        self.portfolios.removeAll()
        let (data, _) = try await URLSession.shared.data(from: url)
        // Parse the JSON data
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawPortfolios = try jsonDecoder.decode([PortfolioResponse].self, from: data)
        for portfolio in rawPortfolios {
            if let imageUrl = URL(string: portfolio.iconUrl), let url = URL(string: portfolio.url), let bundleID = Bundle.main.bundleIdentifier, (portfolio.bundleId ?? "" != bundleID || showCurrentApp) {
                self.downloadImage(from: imageUrl) { image in
                    if let image {
                        DispatchQueue.main.async {
                            self.portfolios.append(Portfolio(name: portfolio.name, image: image, url: url, urlButtonName: portfolio.urlButtonName, bundleID: portfolio.bundleId))
                        }
                    }
                }
            }
        }
        print("Done")
    }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
