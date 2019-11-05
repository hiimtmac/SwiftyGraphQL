//
//  HTTPHeaderName.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct HTTPHeaderName: Hashable {
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

extension HTTPHeaderName {
    public static let accept = HTTPHeaderName("Accept")
    public static let acceptEncoding = HTTPHeaderName("Accept-Encoding")
    public static let authorization = HTTPHeaderName("Authorization")
    public static let contentEncoding = HTTPHeaderName("Content-Encoding")
    public static let contentLength = HTTPHeaderName("Content-Length")
    public static let contentType = HTTPHeaderName("Content-Type")
}
