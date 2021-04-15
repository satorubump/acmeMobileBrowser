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
                HStack(spacing: 10) {
                        Image(systemName: "bookmark")
                        .resizable()
                        .frame(width:20)
                            .aspectRatio(0.75, contentMode: .fit)
                            .foregroundColor(Color.pink)
                        Text("Bookmark")
                        .font(.system(size: 25))
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
