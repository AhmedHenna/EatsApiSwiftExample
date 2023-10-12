//
//  OrderPopUp.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/22/23.
//

import SwiftUI

struct OrderPopupView: View {
    var order: Order
    var accessToken: String
    var store: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            text
            buttons
        }
        .padding()
    }
    
    var text: some View{
        VStack{
            Text("Order ID: \(order.id)")
            Text("Current State: \(order.current_state)")
            Text("Placed At: \(order.placed_at)")
        }
    }
    
    var buttons: some View{
        HStack{
            Button("Accept") {
                
                acceptUberEatsOrder(orderID: order.id, accessToken: accessToken) { result in
                    
                    switch result{
                    case .success:
                        fetchOrderDetails(orderID: order.id, accessToken: accessToken) { order in
                            print(order?.type ?? "NO VALUE")
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                isPresented = false
            }
            
            
            Button("Deny") {
                denyUberEatsOrder(orderID: order.id, accessToken: accessToken) { result in
                    switch result{
                    case .success:
                        print("DENIED")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                isPresented = false
            }
        }
    }
}
