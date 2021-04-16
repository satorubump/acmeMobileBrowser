//
//  AppTabView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/10/21.
//

import SwiftUI

/*
 *  Tab Controller Top View
 */
struct AppTabView: View {
    @ObservedObject var viewModel = MobileWebViewModel()
    @State var currentView = ConstantsTable.First
    var body: some View {
        TabView {
            MobileWebView(viewModel: viewModel, index: ConstantsTable.First)
            .tabItem {
                Image(systemName: "network")
                Text("First")
            }
            MobileWebView(viewModel: viewModel, index: ConstantsTable.Second)
            .tabItem {
                Image(systemName: "network")
                Text("Second")
            }
            BookmarkView(viewModel: viewModel)
            .tabItem {
                Image(systemName: "bookmark")
                Text("Bookmarks")
            }
            ThumbnailHistoryView(viewModel: viewModel)
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Thumbnails")
            }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView(viewModel: MobileWebViewModel())
    }
}

