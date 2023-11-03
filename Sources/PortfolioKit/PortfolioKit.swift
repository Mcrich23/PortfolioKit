// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

public class PortfolioKit: ObservableObject {
    public static let shared = PortfolioKit()
    @Published public private(set) var portfolios: [Portfolio] = []
    
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
