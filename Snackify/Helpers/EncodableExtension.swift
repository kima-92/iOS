//
//  EncodableExtension.swift
//  Snackify
//
//  Created by macbook on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
