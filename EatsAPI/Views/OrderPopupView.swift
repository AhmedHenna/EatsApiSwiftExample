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
                    fetchStoreDetails(storeID: store, accessToken: accessToken) { store in
                        fetchOrderDetails(orderID: order.id, accessToken: accessToken) { user in
                            let distance = calculateDistanceFromStoreToUser(storeLat: store?.location.latitude ?? 0.0,
                                                                            storeLon: store?.location.longitude ?? 0.0,
                                                                            userLat: user?.eater.delivery.location.latitude ?? 0.0,
                                                                            userLon: user?.eater.delivery.location.longitude ?? 0.0)
                            
                            let result = calculateResult(price: user?.paymnet.charges.total.amount ?? 0, distance: distance)
                            
                            
                            if result == true{
                                //if the result is better with Aexir then deny the order on Uber and deliver it with Aexir
                                denyUberEatsOrder(orderID: order.id, accessToken: accessToken) { _ in
                                    print("Order Accetped wit Aexir")
                                }
                                //TODO: Call the method here that will deliver the order using Aexir
                                
                            }else{
                                acceptUberEatsOrder(orderID: order.id, accessToken: accessToken) { accepted in
                                    print("Order Accepted with Uber")
                                }
                            }
                        }
                }
                isPresented = false
            }
            
            
            Button("Deny") {
                denyUberEatsOrder(orderID: order.id, accessToken: accessToken) { _ in
                    print("Order Denied")
                }
                isPresented = false
            }
        }
    }
}
