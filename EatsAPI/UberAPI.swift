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
