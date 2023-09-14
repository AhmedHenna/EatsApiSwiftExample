//
//  UberAuthWebView.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//

import SwiftUI
import WebKit

struct UberAuthWebView: View {
     @Binding var showWebView : Bool
     var redirectURL: String
     @State var onAuthorizationCodeReceived: (String) -> ()
    
    
    var body: some View {
        ZStack{
        }
        .fullScreenCover(isPresented: $showWebView) {
            WebView(url: URL(string: "https://login.uber.com/oauth/v2/authorize?client_id=DldAybkh06QcH_tULEgo0UM_c71UQ4Wn&response_type=code&redirect_uri=\(redirectURL)")!,
                    showWebView: $showWebView,
                    redirectURL: redirectURL,
                    onAuthorizationCodeReceived: onAuthorizationCodeReceived)
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    @Binding var showWebView: Bool
    var redirectURL: String
    var onAuthorizationCodeReceived: (String) -> ()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        var request = URLRequest(url: url)
        request.httpShouldHandleCookies = false
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let urlToMatch = parent.redirectURL
            if let urlStr = navigationAction.request.url?.absoluteString,
               urlStr.hasPrefix(urlToMatch) {
                if let code = URLComponents(string: urlStr)?.queryItems?.first(where: { $0.name == "code" })?.value {
                    parent.showWebView = false
                    parent.onAuthorizationCodeReceived(code)
                }
            }
            decisionHandler(.allow)
        }
    }
}
