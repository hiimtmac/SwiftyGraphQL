//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation
import SwiftyGraphQL

struct TestEncoded<T>: Decodable, Equatable where T: Decodable & Equatable {
    let query: String
    let variables: T
}

struct TestRequest<T: Encodable>: Encodable {
    let data: T?
    let errors: [TestError]?
    
    init(data: T?, errors: [TestError]?) {
        self.data = data
        self.errors = errors
    }
    
    struct TestError: Encodable {
        let message: String
    }
}

extension Data {
    func string() -> String {
        String(decoding: self, as: UTF8.self)
    }
}
