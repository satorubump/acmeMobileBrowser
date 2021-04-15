//
//  AppTabView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/10/21.
//

import SwiftUI

struct AppTabView: View {
    @ObservedObject var viewModel = MobileWebViewModel()
    @State var currentView = 0
    var body: some View {
        TabView {
            MobileWebView(viewModel: viewModel, index: 0)
            .tabItem {
                Image(systemName: "network")
                Text("first")
            }
            MobileWebView(viewModel: viewModel, index: 1)
            .tabItem {
                Image(systemName: "network")
                Text("second")
            }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView(viewModel: MobileWebViewModel())
    }
}

