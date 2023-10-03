//
//  Helpers.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/22/23.
//

import Foundation
import CoreLocation

func calculateDistanceFromStoreToUser(storeLat: Double, storeLon: Double, userLat: Double, userLon: Double) -> Double{
    let storeLocation = CLLocation(latitude: storeLat, longitude: storeLon)
    let orderLocation = CLLocation(latitude: userLat, longitude: userLon)
    let distanceInMeters = storeLocation.distance(from: orderLocation)
    
    let distanceInMiles = distanceInMeters / 1609.34 // 1 mile = 1609.34 meters
    return distanceInMiles
}

func calculateResult(price: Int, distance: Double) -> Bool {
    if price >= 1500 && price < 20 && distance <= 1.5{
        return true
    }
    
    if price >= 2000 && price < 25 && distance <= 2.0{
        return true
    }
    
    if price >= 2500 && price < 30 && distance <= 3.0{
        return true
    }
        
    if price >= 3000 && price < 35 && distance <= 3.5{
        return true
    }
    
    if price >= 3500 && price < 40 && distance <= 3.5{
        return true
    }
    
    if price >= 4000 && distance <= 4.0{
        return true
    }
    
    return false
}
