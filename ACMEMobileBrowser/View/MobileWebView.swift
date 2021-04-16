//
//  ContentView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/10/21.
//

import SwiftUI
import Combine

/*
 *  Browser Main View
 */
struct MobileWebView : View {
    @ObservedObject var viewModel : MobileWebViewModel
    var pindex = ConstantsTable.First
    @State var currentUrl : String = ""
    @State var updateId : Int = ConstantsTable.NoEvent
    @State var isBack : Bool = false
    @State var isForward : Bool = false
    @State var didFinishLoad : Bool = false
    var bmurl = ""
    
    init(viewModel: MobileWebViewModel, index: Int, bm: String = "") {
        self.viewModel = viewModel
        self.pindex = index
        self.bmurl = bm
    }
    var body: some View {
        ZStack {
            VStack {
                urlSection
                WebVCRepresentable(viewModel: viewModel, updateId: $updateId, isBack: $isBack, isForward: $isForward, didFinishLoad: $didFinishLoad, pindex: pindex)
                Spacer()
            }
            if didFinishLoad && pindex != ConstantsTable.Bookmarks {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if viewModel.hasBookmark(index: pindex) == false {
                            HStack {
                                Text("add bookmark")
                                .foregroundColor(Color.pink)
                                Image(systemName:"bookmark.fill")
                                .foregroundColor(Color.gray)
                            }
                            .onTapGesture {
                                viewModel.addBookmark(index: pindex)
                            }
                        }
                        else {
                            Image(systemName:"bookmark.fill")
                            .foregroundColor(Color.red)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarItems(
            trailing:
            HStack(spacing: ConstantsTable.Spacing) {
                if pindex == ConstantsTable.Bookmarks {
                    Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width: ConstantsTable.SymbolFrameWidth)
                        .aspectRatio(ConstantsTable.SymbolRatio, contentMode: .fill)
                        .foregroundColor(Color.pink)
                }
                else if pindex == ConstantsTable.Thumbnails {
                    Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: ConstantsTable.SymbolFrameWidth)
                        .aspectRatio(ConstantsTable.SymbolRatio, contentMode: .fit)
                        .foregroundColor(Color.pink)
                }
            }
        )
        .onAppear() {
            if self.pindex == ConstantsTable.Bookmarks || self.pindex == ConstantsTable.Thumbnails {
                print("onAppear: \(bmurl)")
                self.updateId = ConstantsTable.URLGo
                viewModel.urls[pindex] = bmurl
            }
        }
    }
}

extension MobileWebView {
    var urlSection : some View {
        Section {
            HStack(spacing: ConstantsTable.ButtonSpacing) {
                if isBack {
                    Image(systemName: "chevron.backward")
                    .onTapGesture {
                        updateId = ConstantsTable.Back
                    }
                }
                else {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.gray)
                }
                if isForward {
                    Image(systemName: "chevron.forward")
                    .onTapGesture {
                        updateId = ConstantsTable.Forward
                    }
                }
                else {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(Color.gray)
                }
                Image(systemName: "arrow.clockwise")
                    .onTapGesture {
                        updateId = ConstantsTable.Reload
                    }

                TextField("type a URL", text: $currentUrl, onCommit: {
                    print("URLGo")
                    updateId = ConstantsTable.URLGo
                    viewModel.urls[pindex] = currentUrl
                })
                .onReceive(Just($currentUrl)) { _ in
                    currentUrl = viewModel.urls[pindex]
                }
                .keyboardType(.webSearch)
                .autocapitalization(.none)
                .modifier(ClearButton(text: $currentUrl))
                .position(x: ConstantsTable.URLFieldX, y: ConstantsTable.URLFieldY)
                .frame(width: ConstantsTable.URLFieldWidth, height: ConstantsTable.URLFieldHeight)
            }
            .padding(.leading)
        }
    }
}

struct MobileWebView_Previews: PreviewProvider {
    static var previews: some View {
        MobileWebView(viewModel: MobileWebViewModel(), index: ConstantsTable.First)
    }
}

struct ClearButton: ViewModifier
{
    @Binding var text: String

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                })
                {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
