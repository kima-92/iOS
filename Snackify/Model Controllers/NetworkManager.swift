//
//  NetworkManager.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Properties
    
    #warning("This URL is currently invalid. Replace with API URL before using.")
    private let baseURL: URL = URL(string: "INSERT VALID URL HERE")!
    
    private(set) var user: User?
    private(set) var bearer: Bearer?
    
    // MARK: - Public API
    
    /// Sign up or log in.
    func handleAuth(_ callType: AuthType, with user: User, completion: @escaping (Result<Bearer,NetworkError>) -> Void) {
        let call = callComponents[callType]
        
        guard let authURLComponent = call?.url else {
            completion(.failure(.badAuthURL))
            return
        }
        let authURL = baseURL.appendingPathComponent(authURLComponent)
        
        var request = URLRequest(url: authURL)
            request.httpMethod = call?.httpMethod
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                self.handleResponse(response)
                completion(.failure(.otherError))
                return
            }
            
            if let error = error {
                print(error)
                completion(.failure(.otherError))
                return
            }
            
            if callType == .logIn {
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let receivedBearer = try decoder.decode(Bearer.self, from: data)
                    completion(.success(receivedBearer))
                } catch {
                    print(error)
                    completion(.failure(.noDecode))
                    return
                }
            }
        }.resume()
    }
    
    func fetchSnacks(completion: @escaping (Result<[Snack],NetworkError>) -> Void) {
        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
        let fetchURL = baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE")
        
        var request = URLRequest(url: fetchURL)
        request.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                self.handleResponse(response)
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
    
    // MARK: - Private Methods
    
    private func handleResponse(_ response: HTTPURLResponse) {
        if response.statusCode < 200 || response.statusCode >= 300 {
            print(NSError(domain: "", code: response.statusCode, userInfo: nil))
        }
    }
}

// MARK: - Helper Types

struct HTTPMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

enum NetworkError: String, Error {
    case otherError = "Unknown error occurred: see log for details."
    case badData = "No data received, or data corrupted."
    case noDecode = "JSON could not be decoded. See log for details."
    case noEncode = "JSON could not be encoded. See log for details."
    case badImageURL = "The image URL could not be found."
    case badAuthURL = "The authorization URL could not be found."
}

enum AuthType: String {
    case signUp = "Sign up"
    case logIn = "Log in"
}

#warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
fileprivate let callComponents: [AuthType: (url: String, httpMethod: String)] = [
    .signUp: (
        url: "/users/signup",
        httpMethod: HTTPMethod.post
    ),
    .logIn: (
        url: "/users/login",
        httpMethod: HTTPMethod.post
    )
]
