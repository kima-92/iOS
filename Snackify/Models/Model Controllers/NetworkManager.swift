//
//  NetworkManager.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class NetworkManager {
    #warning("This URL is currently invalid. Replace with API URL before using.")
    let baseURL: URL = URL(string: "INSERT VALID URL HERE")!
    
    var user: User?
    var Bearer: Bearer?
    
    func fetchSnacks(completion: @escaping (Result<[Snack],NetworkError>) -> Void) {
        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
        let fetchURL = baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE")
        
        var request = URLRequest(url: fetchURL)
        request.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                print(NSError(domain: "", code: response.statusCode, userInfo: nil))
                completion(.failure(.otherError))
                return
            }
            
            if let error = error {
                print(error)
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            do {
                let snacks = try JSONDecoder().decode([Snack].self, from: data)
                completion(.success(snacks))
            } catch {
                print(error)
                completion(.failure(.noDecode))
            }
        }.resume()
    }
}

// MARK: - HTTP Methods

struct HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

// MARK: - Network Errors

enum NetworkError: String, Error {
    case otherError = "Unknown error occurred: see log for details."
    case badData = "No data received, or data corrupted."
    case noDecode = "JSON could not be decoded. See log for details."
    case badImageURL = "The image URL could not be found."
}
