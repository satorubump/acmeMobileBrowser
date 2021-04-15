//
//  ContentView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/10/21.
//

import SwiftUI
import Combine

struct MobileWebView : View {
    @ObservedObject var viewModel : MobileWebViewModel
    var pindex = 0
    @State var currentUrl : String = ""
    @State var updateId : Int = 0
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
                WebView(viewModel: viewModel, updateId: $updateId, isBack: $isBack, isForward: $isForward, didFinishLoad: $didFinishLoad, pindex: pindex)
                Spacer()
            }
            if didFinishLoad && pindex != 2 {
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
            HStack(spacing: 10) {
                if pindex == 2 {
                    Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width:20)
                        .aspectRatio(0.5, contentMode: .fit)
                        .foregroundColor(Color.pink)
                }
            }
        )
        .onAppear() {
            if self.pindex == 2 {
                print("onAppear: \(bmurl)")
                self.updateId = 4
                viewModel.urls[pindex] = bmurl
            }
        }
    }
}

extension MobileWebView {
    var urlSection : some View {
        Section {
            HStack(spacing: 15) {
                if isBack {
                    Image(systemName: "chevron.backward")
                    .onTapGesture {
                        updateId = 1
                    }
                }
                else {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.gray)
                }
                if isForward {
                    Image(systemName: "chevron.forward")
                    .onTapGesture {
                        updateId = 2
                    }
                }
                else {
                    Image(systemName: "chevron.forward")
                        .foregroundColor(Color.gray)
                }
                Image(systemName: "arrow.clockwise")
                    .onTapGesture {
                        updateId = 3
                    }

                TextField("e.g. url", text: $currentUrl, onCommit: {
                    updateId = 4
                    viewModel.urls[pindex] = currentUrl
                })
                .onReceive(Just($currentUrl)) { _ in
                    currentUrl = viewModel.urls[pindex]
                }
                .keyboardType(.webSearch)
                .autocapitalization(.none)
                .modifier(ClearButton(text: $currentUrl))
                .position(x: 150, y: 30)
                .frame(width: 300, height: 50)
            }
            .padding(.leading)
        }
    }
}

struct MobileWebView_Previews: PreviewProvider {
    static var previews: some View {
        MobileWebView(viewModel: MobileWebViewModel(), index: 1)
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
