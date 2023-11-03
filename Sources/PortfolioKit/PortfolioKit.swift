// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

public class PortfolioKit: ObservableObject {
    public static let shared = PortfolioKit()
    @Published public private(set) var portfolios: [Portfolio] = []
    
    
    /**
     Configure PortfolioKit and fetch all of your specified data.
     
     - parameter url: The url location for the json file to pull.
     
     
     # Notes: #
        Json files must follow this example:
     ```
     [
       {
         "name": "Pickt",
         "icon_url": "https://static.wixstatic.com/media/193764_6b21a958b29a4b4db9daacb1406e71a8~mv2.png/v1/fill/w_382,h_382,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/pickt.png",
         "url": "https://apps.apple.com/us/app/pickt/id1584491007",
         "url_button_name": "Get"
       }
     ]
     ```
     
     # Example #
     ```
     PortfolioKit.shared.config(with: url)
     ```
     
     */
    public func config(with url: URL) {
        self.portfolios.removeAll()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    // Parse the JSON data
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let rawPortfolios = try jsonDecoder.decode([PortfolioResponse].self, from: data)
                    for portfolio in rawPortfolios {
                        if let imageUrl = URL(string: portfolio.iconUrl), let url = URL(string: portfolio.url) {
                            self.downloadImage(from: imageUrl) { image in
                                if let image {
                                    DispatchQueue.main.async {
                                        self.portfolios.append(Portfolio(name: portfolio.name, image: image, url: url, urlButtonName: portfolio.urlButtonName))
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
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
