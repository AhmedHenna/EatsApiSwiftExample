//
//  OrderRowView.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/22/23.
//

import SwiftUI


struct OrderRowView: View {
    var order: Order
    var accessToken: String
    var store: String
    @State private var isPopupVisible = false

    var body: some View {
        VStack {
            Text("Order ID: \(order.id)")
            Text("Current State: \(order.current_state)")
            Text("Placed At: \(order.placed_at)")
        }
        .onTapGesture {
            isPopupVisible.toggle()
        }
        .sheet(isPresented: $isPopupVisible) {
            OrderPopupView(order: order, accessToken: accessToken, store: store ,isPresented: $isPopupVisible)
        }
    }
}


struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowView(order: Order(id: "1", current_state: "Delivered", placed_at: "2023-09-15 10:00:00"), accessToken: "2", store: "2")
    }
}
