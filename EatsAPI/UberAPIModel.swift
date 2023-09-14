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
