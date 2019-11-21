//
//  SnackManager.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class SnackManager {
    static let shared = SnackManager(networkManager: NetworkManager.shared)
    
    var networkManager: NetworkManager = NetworkManager.shared
    
    let baseURL: URL
    
    var allSnacksOptions: [Snack]?
    var currentOrderSnacks: [Snack] = []
    var subsOrderDeadline: String = "11/23/2019"
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.baseURL = networkManager.baseURL
        fetchSnackOptions { result in
            do {
                self.allSnacksOptions = try result.get()
                print("Fetched all snacks")
            } catch {
                if let error = error as? NetworkError {
                    print(error.rawValue)
                }
            }
        }
    }
    
    func fetchSnackOptions(completion: @escaping (Result<[Snack],NetworkError>) -> Void) {
        let request = networkManager.newRequest(
            url: baseURL.appendingPathComponent("snacks"),
            method: .get)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.networkManager.handleDataTaskResponse(data: data, response: response, error: error) { (result) in
                do {
                    let snackReps = try JSONDecoder().decode([Snack.Representation].self, from: try result.get())
                    let snacks = snackReps.map { snackRep -> Snack in
                        return Snack(fromRepresentation: snackRep)
                    }
                    self.allSnacksOptions = snacks
                    completion(.success(snacks))
                } catch {
                    print(error)
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
    
    func getSnackNutritionInfo(for snack: Snack, completion: @escaping (Result<NutritionInfo,NetworkError>) -> Void) {
        let url = networkManager.baseURL.appendingPathComponent("snacks/\(snack.id)/nutrition")
        let request = networkManager.newRequest(url: url, method: .get)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.networkManager.handleDataTaskResponse(data: data, response: response, error: error) { (result) in
                do {
                    let nutritionInfo = try JSONDecoder().decode(
                        [NutritionInfo].self,
                        from: try result.get())
                    snack.nutritionInfo = nutritionInfo[0]
                    completion(.success(nutritionInfo[0]))
                } catch {
                    if let networkError = error as? NetworkError {
                        completion(.failure(networkError))
                    } else {
                        print(error)
                        completion(.failure(.otherError))
                    }
                }
            }
        }.resume()
    }
    
    func AddSnackToCurrentSubscription(snack: Snack) {
        currentOrderSnacks.append(snack)
    }
    
    func deleteSnackFromCurrentSubscription(snack: Snack) {
        
        //test
        var currentListTest = currentOrderSnacks.map( { $0.name })
        print("Current list \(currentListTest) ")
        
        var snack = currentOrderSnacks.filter( { $0.id != snack.id })
        
        //test
        currentListTest = currentOrderSnacks.map( { $0.name })
        print("Current list after filtering \(currentListTest)")
//        currentOrderSnacks.remove
    }
    
    /// For regular/non-admin employees, make one-time purchases or request additions to the organization snack subscription. If user is an authorized organization administrator, purchase snacks as one-time orders or add them to their regular subscription.
//    func handleOneTimeSnackPurchase(snacks: [Snack], completion: @escaping (Result<Bool,NetworkError>) -> Void) {
//        guard let userData = networkManager.user?.toJSONData() else {
//            completion(.failure(.noEncode))
//            return
//        }
//
//        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
//        let request = networkManager.newRequest(
//            url: baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE"),
//            method: .post,
//            body: userData)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if !self.networkManager.dataTaskDidSucceed(with: response) {
//                completion(.failure(.otherError))
//                return
//            }
//
//            if let error = error {
//                print(error)
//                completion(.failure(.otherError))
//                return
//            }
//            // TODO: Add any further handling of response, data
//            completion(.success(true))
//        }.resume()
//    }
    
//    func fetchSubscription(completion: @escaping (Result<Subscription,NetworkError>) -> Void) {
//        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
//        let request = networkManager.newRequest(
//            url: baseURL.appendingPathComponent("TEMP"),
//            method: .get)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if !self.networkManager.dataTaskDidSucceed(with: response) {
//                completion(.failure(.otherError))
//                return
//            }
//
//            if let error = error {
//                print(error)
//                completion(.failure(.otherError))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(.badData))
//                return
//            }
//
//            do {
//                let subscription = try JSONDecoder().decode(Subscription.self, from: data)
//                completion(.success(subscription))
//            } catch {
//                print(error)
//                completion(.failure(.noDecode))
//            }
//        }.resume()
//    }
    
//    func updateSubscription(_ subscription: Subscription, completion: @escaping (Result<Bool,NetworkError>) -> Void) {
//        guard let userData = networkManager.user?.toJSONData() else {
//            completion(.failure(.noEncode))
//            return
//        }
//
//        #warning("This URL is currently invalid. Modify with actual URL component(s) before using.")
//        let request = networkManager.newRequest(
//            url: baseURL.appendingPathComponent("INSERT PATH COMPONENT(s) HERE"),
//            method: .post,
//            body: userData)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if !self.networkManager.dataTaskDidSucceed(with: response) {
//                completion(.failure(.otherError))
//                return
//            }
//
//            if let error = error {
//                print(error)
//                completion(.failure(.otherError))
//                return
//            }
//            // TODO: Add any further handling of response, data
//            completion(.success(true))
//        }.resume()
//    }
}
