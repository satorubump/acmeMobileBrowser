//
//  ThumbnailsView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/15/21.
//

import SwiftUI

struct ThumbnailsView: View {
    @ObservedObject var viewModel : MobileWebViewModel

    init(viewModel: MobileWebViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                ForEach(self.viewModel.history, id: \.self) { hist in
                    
                    HStack {
                        NavigationLink(destination: MobileWebView(viewModel: viewModel, index: 3, bm: hist.url)) {
                            Image(uiImage: hist.shot)
                                .resizable()
                                .frame(height: 80)
                                .aspectRatio(0.75, contentMode: .fit)
                            Text(hist.url)
                        }
                    }
                }}
            }
            .navigationBarItems(
                leading:
                HStack(spacing: 10) {
                        Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width:20)
                            .aspectRatio(0.75, contentMode: .fit)
                            .foregroundColor(Color.pink)
                        Text("History")
                        .font(.system(size: 25))
                }
            )
        }.onAppear() {
            print("onAppear")
        }
    }
}

struct ThumbnailsView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailsView(viewModel: MobileWebViewModel())
    }
}
