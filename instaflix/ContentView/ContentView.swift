//
//  ContentView.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 6/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ForEach(TabWithIconOption.allCases, id: \.self) { tabItem in
                tab(title: tabItem.title, image: tabItem.rawValue) {
                    content(tab: tabItem)
                }
            }
        }
    }

    private func tab(title: String, image: String, content: () -> (some View)) -> some View {
        content()
        .tabItem {
            VStack(alignment: .center, spacing: 2) {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Text(title)
            }
            .frame(width: 15, height: 15)
        }
    }

    @ViewBuilder
    private func content(tab: TabWithIconOption) -> some View {
        switch tab {
        case .home:
            HomeViewBuilder.buildWithLocalStorage()
        default:
            HStack(alignment: .center) {
                Text("WIP")
            }
        }
    }

}

#Preview {
    ContentView()
}
