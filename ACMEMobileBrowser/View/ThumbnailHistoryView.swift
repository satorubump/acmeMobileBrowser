//
//  ThumbnailHistoryView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/15/21.
//

import SwiftUI

/*
 *  Display user's browsing history list with thumbnails
 */
struct ThumbnailHistoryView: View {
    @ObservedObject var viewModel : MobileWebViewModel

    init(viewModel: MobileWebViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                ForEach(self.viewModel.histories, id: \.self) { hist in
                    
                    HStack {
                        NavigationLink(destination: MobileWebView(viewModel: viewModel, index: ConstantsTable.Thumbnails, bm: hist.url)) {
                            Image(uiImage: hist.shot)
                                .resizable()
                                .frame(height: ConstantsTable.FrameHeight)
                                .aspectRatio(ConstantsTable.SymbolRatio, contentMode: .fit)
                            Text(hist.url)
                        }
                    }
                }}
            }
            .navigationBarItems(
                leading:
                    HStack(spacing: ConstantsTable.Spacing) {
                        Image(systemName: "list.bullet")
                        .resizable()
                            .frame(width: ConstantsTable.SymbolFrameWidth)
                            .aspectRatio(ConstantsTable.SymbolRatio, contentMode: .fit)
                            .foregroundColor(Color.pink)
                        Text("History")
                            .font(.system(size: ConstantsTable.NavibarFontSize))
                }
            )
        }
    }
}

struct ThumbnailHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailHistoryView(viewModel: MobileWebViewModel())
    }
}
