//
//  ContentView.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//



import SwiftUI

struct ContentView: View {
    @State var showWebView = false
    @State private var orders: UberEatsOrder = UberEatsOrder(orders: [])
    @State private var storeID: [String] = []
    @State private var accessToken: String = ""
    
    var body: some View {
        VStack{
            buttons
            displayOrders
            webViewCode
        }
    }
    
    var buttons: some View{
        VStack{
            Button(action: {
                showWebView.toggle()
            }) {
                Text("Open WebView")
            }
            
            Button(action: {
                fetchUberEatsOrders(storeID: storeID.first ?? "", accessToken: accessToken) { orders in
                    if let orders = orders {
                        self.orders = orders
                    }
                }
            }) {
                Text("Refresh Orders")
            }
        }
    }
    
    var displayOrders: some View{
        ScrollView {
                ForEach(orders.orders, id: \.id) { order in
                    OrderRowView(order: order, accessToken: accessToken, store: storeID.first ?? "")
                }
            }
    }
    
    var webViewCode: some View{
        UberAuthWebView(
            showWebView: $showWebView,
            onAuthorizationCodeReceived: { code in
                apiCalls(code: code)
            }
        )
    }
    
    func apiCalls(code: String){
        requestUberApiToken(authorizationCode: code) { result in
            switch result {
            case .success(let uberApi):
                fetchUberEatsStoreIDs(forUserWithAccessToken: uberApi.access_token) { storeID in
                    if let storeID = storeID{
                        self.storeID = storeID
                        authorizeStore(storeID: storeID.first ?? "", accessToken: uberApi.access_token) { _  in
                            requestUberApiTokenWithScopes { result in
                                switch result{
                                case .success(let uberScopeApi):
                                    accessToken = uberScopeApi.access_token
                                    print(accessToken)
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
