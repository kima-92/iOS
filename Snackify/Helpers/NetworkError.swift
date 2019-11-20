//
//  NetworkError.swift
//  Snackify
//
//  Created by macbook on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case otherError = "Unknown error occurred: see log for details."
    case badData = "No data received, or data corrupted."
    case noDecode = "JSON could not be decoded. See log for details."
    case noEncode = "JSON could not be encoded. See log for details."
    case badImageURL = "The image URL could not be found."
    case badAuthURL = "The authorization URL could not be found."
    case noBearer = "The JSON web token is missing."
    case badSubsRepresentation = "Bad Subscription Representation"
    case unexpectedStatusCode = "Unexpected Status Code"
}
