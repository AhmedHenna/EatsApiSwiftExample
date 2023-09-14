//
//  UberAPI.swift
//  EatsAPI
//
//  Created by Ahmed Henna on 9/14/23.
//

import Foundation


func requestUberApiToken(authorizationCode: String, redirectURL: String, completion: @escaping (Result<UberApiResponse, Error>) -> Void) {
    // Define the URL for the API request
    let url = URL(string: "https://login.uber.com/oauth/v2/token")!

    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"


    let parameters: [String: String] = [
        "client_secret": "BzKfGyCeUep4mk--o3U3DgeWONmognx0ilPSNiPn",
        "client_id": "DldAybkh06QcH_tULEgo0UM_c71UQ4Wn",
        "grant_type": "authorization_code",
        "redirect_uri": redirectURL ,
        "code": authorizationCode,
    ]
    
    request.httpBody = parameters.percentEncoded()
    

    // Create a URLSession data task to send the request
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
            // Decode the JSON response into your model
            let decoder = JSONDecoder()
            let uberApi = try decoder.decode(UberApiResponse.self, from: data)
            
            completion(.success(uberApi))
        } catch {
            print("JSON Decoding Error: \(error)")
            completion(.failure(error))
        }
    }

    // Start the URLSession data task
    task.resume()
}

//The following 2 extensions are gonna be used to encode data to the form data format
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
