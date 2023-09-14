//
//  ContentView.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//



import SwiftUI

struct ContentView: View {
    @State var showWebView = false
    //these next vars are not needed they are just used for printing
    @State var accessToken: String = ""
    @State var tokenType: String = ""
    @State var refreshToken: String = ""
    @State var scope: String = ""
    @State var error: String = ""

    var body: some View {
        VStack {
            Button(action: {
                showWebView.toggle()
            }) {
                Text("Open WebView")
            }

            if !accessToken.isEmpty {
                Text("Access Token: \(accessToken)")
                Text("Token Type: \(tokenType)")
                Text("Refresh Token: \(refreshToken)")
                Text("Scope: \(scope)")
            } else if !error.isEmpty {
                Text("Error: \(error)")
            }

            UberAuthWebView(
                showWebView: $showWebView,
                redirectURL: "http://localhost",
                onAuthorizationCodeReceived: { code in
                    requestUberApiToken(authorizationCode: code, redirectURL: "http://localhost") { result in
                        
                        switch result {
                        case .success(let uberApi):
                            accessToken = uberApi.access_token
                            tokenType = uberApi.token_type
                            refreshToken = uberApi.refresh_token
                            scope = uberApi.scope
                            error = "" // Clear any previous errors
                        case .failure(let error):
                            accessToken = ""
                            tokenType = ""
                            refreshToken = ""
                            scope = ""
                            self.error = error.localizedDescription
                        }
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
