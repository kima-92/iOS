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
        let call = authComponents[callType]!

        let request = newRequest(
            url: baseURL.appendingPathComponent(call.url),
            method: call.httpMethod,
            body: user.toJSONData())
        
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
    
    func fetchSnackOptions(completion: @escaping (Result<[Snack],NetworkError>) -> Void) {
        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
        let request = newRequest(
            url: baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE"),
            method: .get)
        
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
    
    // MARK: - CRUD
    
    /// For regular/non-admin employees, make one-time purchases or request additions to the organization snack subscription. If user is an authorized organization administrator, purchase snacks as one-time orders or add them to their regular subscription.
    func handleOneTimeSnackPurchase(snacks: [Snack], completion: @escaping (NetworkError?) -> Void) {
        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
        let requestURL = baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE")
        
        guard let userData = user?.toJSONData() else {
            completion(.noEncode)
            return
        }
        
        let request = newRequest(url: requestURL, method: .post, body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                self.handleResponse(response)
                completion(.otherError)
                return
            }
            
            if let error = error {
                print(error)
                completion(.otherError)
                return
            }
            
            // TODO: Add any further handling of response, data
        }.resume()
    }
    
    func fetchSubscription(completion: @escaping (Result<Subscription,NetworkError>) -> Void) {
        
    }
    
    // MARK: - Private Methods
    
    private func handleResponse(_ response: HTTPURLResponse) {
        if response.statusCode < 200 || response.statusCode >= 300 {
            print(NSError(domain: "", code: response.statusCode, userInfo: nil))
        }
    }
    
    private func newRequest(url: URL, method: HTTPMethod, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch method {
        case .post, .put:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}

// MARK: - Helper Types

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
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
fileprivate let authComponents: [AuthType: (url: String, httpMethod: HTTPMethod)] = [
    .signUp: (
        url: "/users/signup",
        httpMethod: HTTPMethod.post
    ),
    .logIn: (
        url: "/users/login",
        httpMethod: HTTPMethod.post
    )
]

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
