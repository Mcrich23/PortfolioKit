//
//  PortfolioView.swift
//
//
//  Created by Morris Richman on 11/3/23.
//

import Foundation
import SwiftUI

public struct PortfolioView: View {
    @ObservedObject var portfolioKit = PortfolioKit.shared
    let backgroundColor: Color
    public init() {
        let redGreenBlue: Double = 242/255
        self.backgroundColor = Color(red: redGreenBlue, green: redGreenBlue, blue: redGreenBlue)
    }
    
    public var body: some View {
        List {
            ForEach(portfolioKit.portfolios) { portfolio in
                HStack {
                    Image(uiImage: portfolio.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text(portfolio.name)
                    Spacer()
                    Link(portfolio.urlButtonName, destination: portfolio.url)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(backgroundColor))
                }
            }
        }
    }
    
    public func title(_ title: String) -> some View {
        PortfolioView().modifier(NavigationModifier(title: title))
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
