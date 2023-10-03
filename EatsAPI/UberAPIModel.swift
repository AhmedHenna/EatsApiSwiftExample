//
//  UberAPIModel.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//

import Foundation

struct UberApiResponse: Codable {
    var access_token: String
    var token_type: String
    var refresh_token: String
    var scope: String
}

struct UberApiResponseWithScopes: Codable {
    var access_token: String
    var token_type: String
    var expires_in: Int
    var scope: String
}

struct UberEatsStores: Codable{
    var stores: [Stores]
}

struct Stores: Codable{
    var store_id: String
    var location: StoreLocation
}

struct StoreLocation: Codable{
    var latitude: Double
    var longitude: Double
}

struct UberEatsOrder: Codable, Identifiable {
    var id: UUID = UUID()
    var orders: [Order]
}

struct Order: Codable {
    var id: String
    var current_state: String
    var placed_at: String
}

struct UberOrderDetails: Codable {
    var id: String
    var eater: Eater
    var paymnet: Payment
}

struct Eater: Codable{
    var delivery: Delivery
}

struct Payment: Codable{
    var charges: Charges
}

struct Charges: Codable{
    var total: Money
}

struct Money: Codable{
    var amount: Int
    var formatted_amount: String
}

struct Delivery: Codable{
    var location: Location
}

struct Location: Codable{
    var latitude: Double
    var longitude: Double
}

