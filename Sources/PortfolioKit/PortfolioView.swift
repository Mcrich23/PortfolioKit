//
//  PortfolioView.swift
//
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation
import SwiftUI
import StoreKit

#if canImport(SafariServices)
import SafariServices
#endif

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
    
    func image(_ portfolio: Portfolio) -> some View {
#if canImport(UIKit)
        return (Image(uiImage: portfolio.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50))
#endif
                        
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        return (Image(nsImage: portfolio.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50))
#endif
    }
    
    func presentStoreKitProduct(_ portfolio: Portfolio) {
        #if os(iOS)
        if let storekitProduct = portfolio.storekitProduct {
            self.presentVC(storekitProduct)
        } else {
            portfolioKit.loadProduct(portfolio) { storekitProduct in
                if let storekitProduct {
                    self.presentVC(storekitProduct)
                }
            }
        }
        #elseif os(macOS)
        NSWorkspace.shared.open(portfolio.url)
        #elseif canImport(SafariServices)
        let safariVC = SFSafariViewController(url: portfolio.url)
        presentVC(safariVC)
        #elseif canImport(UIKit)
            #if os(tvOS)
            if let url = URL(string: "com.apple.TVAppStore://\(portfolio.url.absoluteString)") {
                UIApplication.shared.open(url)
            }
            #else
            UIApplication.shared.open(portfolio.url)
            #endif
        #endif
    }
    
    public var body: some View {
        List {
            if portfolioKit.portfolios.isEmpty {
                ProgressView()
            } else {
                ForEach(portfolioKit.portfolios) { portfolio in
                    HStack {
                        image(portfolio)
                        Text(portfolio.name)
                        Spacer()
                        if portfolio.urlIsAppStore && portfolioKit.builtInStorekitEnabled {
                            Button(portfolio.urlButtonName) {
                                self.presentStoreKitProduct(portfolio)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 3)
                            .font(.body.bold())
                            #if os(tvOS)
                                .buttonStyle(PlainButtonStyle())
                            #else
                                .background(Capsule().fill(backgroundColor))
                            #endif
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
    
#if canImport(UIKit)
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
    private func presentVC(_ viewController: UIViewController) {
        topVC().present(viewController, animated: true, completion: nil)
    }
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    private func topVC() -> NSViewController? {
        guard let topWindow = NSApplication.shared.windows.first(where: { $0.isMainWindow }) else {
            return nil
        }
        
        var topVC = topWindow.contentViewController
        
        // Iterate until we find the topmost presented view controller
        // If you don't, you might get an error when presenting multiple VCs at the same level
        while let presentedVC = topVC?.presentedViewControllers?.first {
            topVC = presentedVC
        }
        
        return topVC
    }
    private func presentVC(_ viewController: NSViewController) {
        topVC()?.presentAsSheet(viewController)
    }
#endif
}

struct NavigationModifier: ViewModifier {
  let title: String

  func body(content: Content) -> some View {
      #if os(macOS)
      if #available(macOS 13, *) {
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
      #elseif os(iOS)
      if #available(iOS 16, *) {
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
      #else
      NavigationView {
          content
              .navigationTitle(title)
      }
      #endif
  }
}
