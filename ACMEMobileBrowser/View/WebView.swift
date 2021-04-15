//
//  WebView.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/11/21.
//

import SwiftUI
import WebKit


struct WebView: UIViewControllerRepresentable {
    var viewModel : MobileWebViewModel
    @Binding var updateId: Int
    let pindex : Int

    func makeUIViewController(context: Context) -> EmbeddedWebviewController {
        let webViewController = EmbeddedWebviewController(coordinator: context.coordinator)
        return webViewController
    }

    func updateUIViewController(_ uiViewController: EmbeddedWebviewController, context: Context) {
        print("updateUIViewController updateId: \(updateId)")
        
        switch(updateId) {
        case 1:
            uiViewController.goBack()
        case 2:
            uiViewController.goForward()
        case 3:
            uiViewController.reload()
        case 4:
            uiViewController.loadUrl(viewModel.urls[pindex])
        default:
            print("updateUIView default")
        }
        updateId = 0
    }

    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent : WebView
        
        init(_ parent: WebView) {
             self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("load started")
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("load finished \(webView.url!))")
            UIApplication.shared.closeKeyboard()
            let url = webView.url
            if let surl = url?.absoluteString {
                parent.viewModel.urls[parent.pindex] = surl
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("didfaileProvisionalNavigation error")
            
            var surl = parent.viewModel.urls[parent.pindex]
            print("surl: \(surl)")
            let l = surl.count
            if l > 11 && surl.prefix(10) != "http://www" {
                surl = surl.prefix(7) + "www" + surl.suffix(l - 10)
            }
            parent.viewModel.urls[parent.pindex] = surl

        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("error")
            //print(error)
        }
    }
}

struct WebView_Previews: PreviewProvider {

    static var previews: some View {
        VStack{
            //WebView(req: self.makeURLRequest())
        }
    }

    static func makeURLRequest() -> URLRequest {
        let request = URLRequest(url: URL(string: "https://www.google.com")!)
        return request
    }
}
