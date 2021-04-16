//
//  EmbeddedWebViewController.swift
//  ACMEMobileBrowser
//
//  Created by Satoru Ishii on 4/12/21.
//

import WebKit

class EmbeddedWebviewController: UIViewController {

    var webview: WKWebView

    public var delegate: WebVCRepresentable.Coordinator? = nil

    init(coordinator: WebVCRepresentable.Coordinator) {
        self.delegate = coordinator
        self.webview = WKWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.webview = WKWebView()
        super.init(coder: coder)
    }

    public func loadUrl(_ url: String?) {
        print("loadUrl")
        guard var surl = url else {
            return
        }
        if surl.prefix(5) != "https" {
            surl = "https://" + surl
        }
        guard let url = URL(string: surl) else {   print("loadUrl error"); return  }
        print("loadUrl: \(url.absoluteString)")
        webview.load(URLRequest(url: url))
    }

    public func reload() {
        webview.reload()
    }
    public func goBack() {
        webview.goBack()
    }
    public func goForward() {
        webview.goForward()
    }
    public func canGoBack() -> Bool {
        return webview.canGoBack
    }
    public func canGoForward() -> Bool {
        return webview.canGoForward
    }
    
    override func loadView() {
        self.webview.navigationDelegate = self.delegate
        self.webview.uiDelegate = self.delegate
        self.view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


