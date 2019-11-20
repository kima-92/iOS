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
    
    static let shared = NetworkManager()
    
    // MARK: - Login/Sign-up
    
    /// Handles sign-up for employees.
    func signUp(with user: User, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        let userRep = user.representation
        guard let userData = userRep.toJSONData() else {
            completion(.failure(.noEncode))
            return
        }
        
        let request = newRequest(
            url: baseURL.appendingPathComponent("/auth/register/employee"),
            method: .post,
            body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleDataTaskResponse(data: data, response: response, error: error, dataHandler: completion)
        }.resume()
    }
    
    func logIn(with username: String, password: String, completion: @escaping (Result<Bearer,NetworkError>) -> Void) {
        let userData: Data
        do {
            userData = try JSONEncoder().encode([
                "username": username,
                "password": password])
        } catch {
            print(error)
            completion(.failure(.noEncode))
            return
        }
        
        let request = newRequest(
            url: baseURL.appendingPathComponent("/auth/login/employee"),
            method: .post,
            body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleDataTaskResponse(data: data, response: response, error: error) { result in
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                do {
                    let token = try JSONDecoder().decode(Bearer.self, from: data)
                    self.bearer = token
                    completion(.success(token))
                } catch {
                    print(error)
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
    
    func logOut() {
        bearer = nil
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
            print(response)
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
        
        if let bearer = bearer {
            request.setValue(bearer.token, forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    //MARK: Subscription Methods
}

// MARK: - Helper Types





enum AuthType: String {
    case signUp = "Sign up"
    case logIn = "Log in"
}
extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
