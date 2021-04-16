//
//  BookmarkView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/14/21.
//

import SwiftUI

struct BookmarkView: View {
    @ObservedObject var viewModel : MobileWebViewModel

    init(viewModel: MobileWebViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.bookmarks, id: \.self) { bmark in
                    NavigationLink(destination: MobileWebView(viewModel: viewModel, index: ConstantsTable.Bookmarks, bm: bmark)) {
                        HStack {
                            Image(systemName: "bookmark")
                                .foregroundColor(Color.blue)
                            Text(bmark)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
            .navigationBarItems(
                leading:
                    HStack(spacing: ConstantsTable.Spacing) {
                        Image(systemName: "bookmark")
                        .resizable()
                            .frame(width: ConstantsTable.SymbolFrameWidth)
                            .aspectRatio(ConstantsTable.SymbolRatio, contentMode: .fit)
                            .foregroundColor(Color.pink)
                        Text("Bookmarks")
                            .font(.system(size: ConstantsTable.NavibarFontSize))
                }
            )
        }
        .onAppear() {
            viewModel.updateBookmarkList()
        }
    }
}

struct BookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView(viewModel: MobileWebViewModel())
    }
}
