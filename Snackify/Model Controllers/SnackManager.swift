//
//  SnackManager.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class SnackManager {
    
    // MARK: - Properties
    
    var networkManager: NetworkManager
    
    let baseURL: URL
    
    var allSnacksOptions: [Snack]?
    var currentOrderSnacks: [Snack] = []
    var subsOrderDeadline: String = "11/23/2019"
    
    // MARK: - Init
    
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
    
    // MARK: - Methods
    
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
    
    func addSnackToCurrentSubscription(_ snack: Snack) {
        currentOrderSnacks.append(snack)
    }
}
