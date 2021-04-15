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
    @Binding var isBack : Bool
    @Binding var isForward : Bool
    @Binding var didFinishLoad : Bool
    let pindex : Int

    func makeUIViewController(context: Context) -> EmbeddedWebviewController {
        let webViewController = EmbeddedWebviewController(coordinator: context.coordinator)
        return webViewController
    }

    func updateUIViewController(_ uiViewController: EmbeddedWebviewController, context: Context) {
        
        switch(updateId) {
        case ConstantsTable.Back:
            uiViewController.goBack()
        case ConstantsTable.Forward:
            uiViewController.goForward()
        case ConstantsTable.Reload:
            uiViewController.reload()
        case ConstantsTable.URLGo:
            uiViewController.loadUrl(viewModel.urls[pindex])
        default:
            print("updateUIView default")
        }
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
            parent.isBack = webView.canGoBack
            parent.isForward = webView.canGoForward
            parent.didFinishLoad = true

            if parent.pindex == ConstantsTable.Thumbnails {
                return
            }
            if let sshot = webView.takeScreenShot() {
                //print("Coordinator didFinish \(sshot)")
                parent.viewModel.updateHistory(index: parent.pindex, shot: sshot)
            }
            parent.updateId = ConstantsTable.NoEvent
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            //print("didfaileProvisionalNavigation error")
            
            var surl = parent.viewModel.urls[parent.pindex]
            print("surl: \(surl)")
            let l = surl.count
            if l > 11 && surl.prefix(10) != "http://www" {
                surl = surl.prefix(7) + "www" + surl.suffix(l - 10)
            }
            parent.viewModel.urls[parent.pindex] = surl
        }
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("didFail")
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

extension WKWebView {
    public func takeScreenShot() -> UIImage? {
        
        print("takeScreenShot 1")
        let width = CGFloat(UIScreen.main.bounds.size.width)
        
        let height = CGFloat(UIScreen.main.bounds.size.height/1.3)
        let size = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        print("takeScreenShot 2")

        return screenShotImage
    }
}
