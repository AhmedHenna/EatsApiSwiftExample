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

struct Order: Codable {
    let id: String
    let current_state: String
    let placed_at: String

    enum CodingKeys: String, CodingKey {
        case id
        case current_state = "current_state"
        case placed_at = "placed_at"
    }
}

struct UberEatsOrder: Codable {
    let orders: [Order]
}

struct UberOrderDetails: Codable {
    var id: String
    var type: String
}
