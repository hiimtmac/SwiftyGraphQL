//
//  HTTPHeader.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct HTTPHeader {
    let name: HTTPHeaderName
    let value: String
    
    public init(name: HTTPHeaderName, value: String) {
        self.name = name
        self.value = value
    }
    
    public init(name: HTTPHeaderName, value: MediaType) {
        self.name = name
        self.value = value.serialize()
    }
}
