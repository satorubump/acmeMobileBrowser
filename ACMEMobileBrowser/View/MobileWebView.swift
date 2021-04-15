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
    
    init(viewModel: MobileWebViewModel, index: Int) {
        self.viewModel = viewModel
        self.pindex = index
    }
    var body: some View {
        VStack {
            urlSection
            WebView(viewModel: viewModel, updateId: $updateId, pindex: pindex)
            Spacer()
        }
    }
}

extension MobileWebView {
    var urlSection : some View {
        Section {
            HStack(spacing: 15) {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        updateId = 1
                    }
                Image(systemName: "chevron.forward")
                    .onTapGesture {
                        updateId = 2
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
