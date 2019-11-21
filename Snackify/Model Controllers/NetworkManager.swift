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
    
    static let shared = NetworkManager()
    
    // MARK: - Login/Sign-up
    
    /// Handles sign-up for employees.
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
            print(error)
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
                    // TODO: parse response from token to get role
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
    
    func addNewSubscription(subscription: Subscription, completion: @escaping () -> Void = { }) {
        
        //        let id = subscription.id
        //        subscription.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent("subs")
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let subsRepresentation = subscription.representation else {
            NSLog("Subscription Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(subsRepresentation)
        } catch {
            NSLog("Error encoding subcription representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting subscription: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    
    func getSnacksInSubscription(subscription: Subscription, completion: @escaping (Result<[Snack.Representation], NetworkError>) -> Void) {
        
        guard let bearer = bearer else {
            completion(Result.failure(NetworkError.noBearer))
            return
        }
        
        guard let subsRepresentation = subscription.representation else {
            completion(Result.failure(NetworkError.badSubsRepresentation))
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("subs")
            .appendingPathComponent("\(subsRepresentation.id)")
            .appendingPathComponent("snacks")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: HeaderNames.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error fetching snacks from subscription: \(error)")
                completion(Result.failure(NetworkError.otherError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(Result.failure(NetworkError.unexpectedStatusCode))
            }
            
            guard let data = data else {
                completion(Result.failure(NetworkError.badData))
                return
            }
            
            do {
                let snacks = try JSONDecoder().decode([Snack.Representation].self, from: data)
                completion(Result.success(snacks))
            } catch {
                NSLog("Error decoding snacks: \(error)")
                completion(Result.failure(NetworkError.noDecode))
            }
        }.resume()
    }
}


