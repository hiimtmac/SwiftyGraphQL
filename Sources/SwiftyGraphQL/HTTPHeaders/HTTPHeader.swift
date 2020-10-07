//
//  HTTPHeader.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct HTTPHeader {
    public let name: HTTPHeaderName
    public let value: String
    
    public init(_ name: HTTPHeaderName, value: String) {
        self.name = name
        self.value = value
    }
    
    public init(_ name: HTTPHeaderName, value: MediaType) {
        self.name = name
        self.value = value.serialize()
    }
}
