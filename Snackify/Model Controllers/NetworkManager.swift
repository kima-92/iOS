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
    
    private(set) var username: String?
    private(set) var bearer: Bearer?
    
    private(set) var userType: UserType?
    
    // MARK: - Login/Sign-up
    
    func signUp(with user: User, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        let userData: Data
        let registrationEndpoint: String
        if user.isOrganization {
            guard let orgData = user.orgRepresentation?.toJSONData()
                else {
                    completion(.failure(.noEncode))
                    return
            }
            userData = orgData
            registrationEndpoint = "organization"
        } else {
            guard let employeeData = user.employeeRepresentation?.toJSONData()
                else {
                    completion(.failure(.noEncode))
                    return
            }
            userData = employeeData
            registrationEndpoint = "employee"
        }
        
        let request = newRequest(
            url: baseURL.appendingPathComponent("/auth/register/\(registrationEndpoint)"),
            method: .post,
            body: userData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleDataTaskResponse(data: data, response: response, error: error, dataHandler: completion)
        }.resume()
    }
    
    func logIn(with username: String, password: String, isOrganization: Bool, completion: @escaping (Result<Bearer,NetworkError>) -> Void) {
        let userData: Data
        do {
            userData = try JSONEncoder().encode([
                "username": username,
                "password": password])
        } catch {
            NSLog("\(error)")
            completion(.failure(.noEncode))
            return
        }
        
        let loginEndpoint = isOrganization ? "organization" : "employee"
        
        let request = newRequest(
            url: baseURL.appendingPathComponent("/auth/login/\(loginEndpoint)"),
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
                    
                    if isOrganization {
                        self.userType = .organization
                    } else if token.role == "orgAdmin" {
                        self.userType = .orgAdmin
                    } else {
                        self.userType = .employee
                    }
                    
                    self.username = username
                    
                    completion(.success(token))
                } catch {
                    NSLog("\(error)")
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
            NSLog("\(error)")
            dataHandler(.failure(.otherError))
            return
        }
        if let data = data {
            dataHandler(.success(data))
        } else {
            dataHandler(.failure(.badData))
        }
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
    
    func dataTaskDidSucceed(with response: URLResponse?) -> Bool {
        if let response = response as? HTTPURLResponse,
            response.statusCode < 200 || response.statusCode >= 300 {
            NSLog("\(response)")
            NSLog("\(NSError(domain: "", code: response.statusCode, userInfo: nil))")
            return false
        }
        return true
    }
}
