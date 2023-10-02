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
                acceptUberEatsOrder(orderID: order.id, accessToken: accessToken) { _ in
                    //TODO implement a way to check both distance and price and depedning on that use uber eats or the normal delivery
                }
                isPresented = false
            }
            Button("Deny") {
                denyUberEatsOrder(orderID: order.id, accessToken: accessToken) { _ in
                    //TODO delete order from list
                }
                isPresented = false
            }
        }
    }
}
