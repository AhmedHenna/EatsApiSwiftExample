//
//  UberAPI.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//

import Foundation


func requestUberApiToken(authorizationCode: String, completion: @escaping (Result<UberApiResponse, Error>) -> Void) {
    let url = URL(string: Constants.UBER_AUTH_URL)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    
    let parameters: [String: String] = [
        "client_secret": Constants.CLIENT_SECRET,
        "client_id": Constants.CLIENT_ID,
        "grant_type": "authorization_code",
        "redirect_uri": Constants.REDIRECT_URI ,
        "code": authorizationCode,
        "scope": "eats.pos_provisioning"
    ]
    
    request.httpBody = parameters.percentEncoded()
    
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let uberApi = try decoder.decode(UberApiResponse.self, from: data)
            
            completion(.success(uberApi))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }
    
    task.resume()
}

func fetchUberEatsStoreIDs(forUserWithAccessToken accessToken: String, completion: @escaping ([String]?) -> Void) {
    guard let url = URL(string: Constants.STORES_ID) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching UberEats stores: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let uberEatsStores = try decoder.decode(UberEatsStores.self, from: data)
                
                let storeIDs = uberEatsStores.stores.map { $0.store_id }
                completion(storeIDs)
            } catch {
                print("Error decoding UberEats stores: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }.resume()
}

func authorizeStore(storeID: String, accessToken: String, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "https://api.uber.com/v1/eats/stores/\(storeID)/pos_data") else {
        print("Invalid URL")
        completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error authorizing store: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        completion(nil)
    }
    
    task.resume()
}

func requestUberApiTokenWithScopes(completion: @escaping (Result<UberApiResponseWithScopes, Error>) -> Void) {
    let url = URL(string: Constants.UBER_AUTH_URL)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    
    let parameters: [String: String] = [
        "client_secret": Constants.CLIENT_SECRET,
        "client_id": Constants.CLIENT_ID,
        "grant_type": "client_credentials",
        "scope": "eats.store eats.order eats.store.orders.read"
    ]
    
    request.httpBody = parameters.percentEncoded()
    
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let uberApi = try decoder.decode(UberApiResponseWithScopes.self, from: data)
            
            completion(.success(uberApi))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }
    
    task.resume()
}

func fetchUberEatsOrders(storeID: String, accessToken: String, completion: @escaping (UberEatsOrder?) -> Void) {
    guard let url = URL(string: "https://api.uber.com/v1/eats/stores/\(storeID)/created-orders") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching orders: \(error.localizedDescription)")
            completion(nil)
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 date format
                let decodedResponse = try decoder.decode(UberEatsOrder.self, from: data)
                completion(decodedResponse)
            } catch {
                print("Error decoding orders: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }.resume()
}

func fetchStoreDetails(storeID: String, accessToken: String, completion: @escaping (Stores?) -> Void) {
    guard let url = URL(string: "\(Constants.STORES_ID)/\(storeID)") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching store: \(error.localizedDescription)")
            completion(nil)
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                let decodedStore = try decoder.decode(Stores.self, from: data)
                completion(decodedStore)
            } catch {
                print("Error decoding store: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }.resume()
}

func fetchOrderDetails(orderID: String, accessToken: String, completion: @escaping (UberOrderDetails?) -> Void) {
    guard let url = URL(string: "\(Constants.ORDER_DETAILS)\(orderID)") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching order: \(error.localizedDescription)")
            completion(nil)
            return
        }

        if let data = data {
            do {
                let decoder = JSONDecoder()
                let decodedOrder = try decoder.decode(UberOrderDetails.self, from: data)
                completion(decodedOrder)
            } catch {
                print("Error decoding order: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }.resume()
}

func acceptUberEatsOrder(orderID: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let url = URL(string: "\(Constants.ORDER_STATUS)\(orderID)/accept_pos_order") else {
        print("Invalid URL")
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            print("Error accepting order: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        // Check for successful response status codes here if needed
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                print("Failed to accept order. Status code: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "Failed to accept order", code: httpResponse.statusCode, userInfo: nil)))
            }
        }
    }.resume()
}

func denyUberEatsOrder(orderID: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let url = URL(string: "\(Constants.ORDER_STATUS)\(orderID)/deny_pos_order") else {
        print("Invalid URL")
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            print("Error denying order: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        // Check for successful response status codes here if needed
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                print("Failed to deny order. Status code: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "Failed to deny order", code: httpResponse.statusCode, userInfo: nil)))
            }
        }
    }.resume()
}


//The following 2 extensions are used to encode data to the form data format
// SOURCE: https://sagar-r-kothari.github.io/swift/2020/02/20/Swift-Form-Data-Request.html
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
