//
//  PortfolioView.swift
//
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation
import SwiftUI
import StoreKit

/**
 The default view to display portfolio data.
 
 # Notes: #
 1. Use the `.title(_:)` modifier to add a navigation view and title to PortfolioView.
 
 # Example #
 ```
 struct ContentView: View {
   var body: some View {
       PortfolioView()
           .title("Check Out My Apps") // Add a navigation title to the view
   }
 }
 ```
 
 */
public struct PortfolioView: View {
    @ObservedObject var portfolioKit = PortfolioKit.shared
    let backgroundColor: Color
    public init() {
        let redGreenBlue: Double = 242/255
        self.backgroundColor = Color(red: redGreenBlue, green: redGreenBlue, blue: redGreenBlue)
    }
    
    public var body: some View {
        List {
            if portfolioKit.portfolios.isEmpty {
                ProgressView()
            } else {
                ForEach(portfolioKit.portfolios) { portfolio in
                    HStack {
                        Image(uiImage: portfolio.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text(portfolio.name)
                        Spacer()
                        if portfolio.urlIsAppStore {
                            Button(portfolio.urlButtonName) {
                                if let storekitProduct = portfolio.storekitProduct {
                                    topVC().present(storekitProduct, animated: true, completion: nil)
                                } else {
                                    portfolioKit.loadProduct(portfolio) { storekitProduct in
                                        if let storekitProduct {
                                            topVC().present(storekitProduct, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(backgroundColor))
                                .font(.body.bold())
                        } else {
                            Link(portfolio.urlButtonName, destination: portfolio.url)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(backgroundColor))
                                .font(.body.bold())
                        }
                    }
                }
            }
        }
    }
    
    /**
     Add a navigation view and title to PortfolioView.
     
     - parameter title: The desired navigation title.
     - returns: `some View`
     */
    public func title(_ title: String) -> some View {
        PortfolioView().modifier(NavigationModifier(title: title))
    }
    
    private func topVC() -> UIViewController {
        guard var topVC = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController else {
            return (UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController)!
        }
        // iterate til we find the topmost presented view controller
        // if you don't you'll get an error since you can't present 2 vcs from the same level
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
}

struct NavigationModifier: ViewModifier {
  let title: String

  func body(content: Content) -> some View {
      if #available(iOS 16.0, *) {
          NavigationStack {
              content
                  .navigationTitle(title)
          }
      } else {
          NavigationView {
              content
                  .navigationTitle(title)
          }
      }
  }
}
