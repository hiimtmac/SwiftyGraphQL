//
//  HTTPHeaders.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct HTTPHeaders {
    public var headers: [HTTPHeaderName: String]

    public init() {
        self.headers = [:]
    }
    
    public init(_ headers: [HTTPHeader]) {
        let map = headers.map { ($0.name, $0.value) }
        self.headers = Dictionary.init(map) { $1 }
    }
    
    public init(_ headers: [HTTPHeaderName: String]) {
        self.headers = headers
    }
    
    public subscript(_ name: HTTPHeaderName) -> String? {
        return headers[name]
    }
    
    public mutating func add(_ header: HTTPHeader) {
        self.headers[header.name] = header.value
    }
    
    public mutating func remove(_ name: HTTPHeaderName) {
        headers[name] = nil
    }
}

extension HTTPHeaders {
    public static func +(lhs: Self, rhs: Self) -> Self {
        let headers = lhs.headers + rhs.headers
        return HTTPHeaders(headers)
    }
}

extension Dictionary where Key == HTTPHeaderName, Value == String {
    static func +(lhs: Self, rhs: Self) -> Self {
        return lhs.merging(rhs) { $1 }
    }
}
