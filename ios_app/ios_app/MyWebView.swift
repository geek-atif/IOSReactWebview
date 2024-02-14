//
//  MyWebView.swift
//  webview-test

import SwiftUI
import WebKit
import Combine

protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
}

struct MyWebView: UIViewRepresentable, WebViewHandlerDelegate {
    
    // Receiving data from React JS to IOS
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("Received from React app : \(value)")
        viewModel.showAlert.send(true)
        viewModel.callbackValueFromReactJS.send(value.first?.value as! String)
    }
    
    let url: URL?
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("makeUIView")
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        config.userContentController.add(self.makeCoordinator(), name: "IOS_BRIDGE")
        
        let webview = WKWebView(frame: .zero, configuration: config)
        
        webview.navigationDelegate = context.coordinator
        webview.allowsBackForwardNavigationGestures = false
        webview.scrollView.isScrollEnabled = true
        webview.isInspectable = true // For Debug 
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myUrl = url else {
            return
        }
        let request = URLRequest(url: myUrl)
        uiView.load(request)
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: MyWebView
        var callbackValueFromNative: AnyCancellable? = nil
        
        var delegate: WebViewHandlerDelegate?
        
        init(_ uiWebView: MyWebView) {
            self.parent = uiWebView
            self.delegate = parent
        }
        
        deinit {
            callbackValueFromNative?.cancel()
        }
        
        func webView(_ webview: WKWebView, didFinish: WKNavigation!) {
            print("webView didFinish")
            
            webview.evaluateJavaScript("document.title") { (response, error) in
                if let error = error {
                    print("title error")
                    print(error)
                }
                if let title = response as? String {
                    self.parent.viewModel.webTitle.send(title)
                }
            }
            
            // sending data from IOS to React JS
            self.callbackValueFromNative = self.parent.viewModel.callbackValueFromNative
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    let js = "var event = new CustomEvent('iosEvent', { detail: { data: '\(value)'}}); window.dispatchEvent(event);"
                    webview.evaluateJavaScript(js, completionHandler: { (response, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("Successfully sent data React app : \((value))")
                        }
                    })
                })
        }
    }
}

extension MyWebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "IOS_BRIDGE" {
            delegate?.receivedJsonValueFromWebView(value: message.body as! [String : Any?])
        }
    }
}
