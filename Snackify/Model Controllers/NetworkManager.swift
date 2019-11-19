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
    
    let baseURL: URL = URL(string: "https://snackify7.herokuapp.com")!
    
    private(set) var user: User?
    private(set) var bearer: Bearer?
    
    // MARK: - Users
    
    /// Sign up or log in.
    
    func signUp(with user: User, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        guard let userData = user.toJSONData() else {
            completion(.failure(.noEncode))
            return
        }
        
        let request = newRequest(
            url: baseURL.appendingPathComponent("/auth/register/employee"),
            method: .post,
            body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleDataTaskResponse(data: data, response: response, error: error, dataHandler: completion)
        }
    }
    
    func handleAuth(_ callType: AuthType, with user: User, completion: @escaping (Result<Bearer,NetworkError>) -> Void) {
        let call = authComponents[callType]!
        
        guard let userData = user.toJSONData() else {
            completion(.failure(.noEncode))
            return
        }

        let request = newRequest(
            url: baseURL.appendingPathComponent(call.url),
            method: call.httpMethod,
            body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if !self.dataTaskDidSucceed(with: response) {
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
    
    // MARK: - Helper Methods
    
    func handleDataTaskResponse(data: Data?, response: URLResponse?, error: Error?, dataHandler: @escaping (Result<Data,NetworkError>) -> Void) {
        if !dataTaskDidSucceed(with: response) {
            dataHandler(.failure(.otherError))
            return
        }
        if let error = error {
            print(error)
            dataHandler(.failure(.otherError))
            return
        }
        if let data = data {
            dataHandler(.success(data))
        } else {
            dataHandler(.failure(.badData))
        }
    }
    
    func dataTaskDidSucceed(with response: URLResponse?) -> Bool {
        if let response = response as? HTTPURLResponse,
            response.statusCode < 200 || response.statusCode >= 300 {
            print(NSError(domain: "", code: response.statusCode, userInfo: nil))
            return false
        }
        return true
    }
    
    func newRequest(url: URL, method: HTTPMethod, body: Data? = nil) -> URLRequest {
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
        url: "/auth/register/employee",
        httpMethod: HTTPMethod.post
    ),
    .logIn: (
        url: "/auth/login/employee",
        httpMethod: HTTPMethod.post
    )
]

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
