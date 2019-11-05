//
//  MediaType.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct MediaType: Hashable {
    let type: String
    let subType: String
    let parameters: [String: String]
    
    public init(type: String, subType: String, parameters: [String: String] = [:]) {
        self.type = type
        self.subType = subType
        self.parameters = parameters
    }
    
    public func serialize() -> String {
        var string = "\(type)/\(subType)"
        for (key, val) in parameters {
            string += "; \(key)=\(val)"
        }
        return string
    }
}

extension MediaType {
    public static let any = MediaType(type: "*", subType: "*")
    public static let plainText = MediaType(type: "text", subType: "plain", parameters: ["charset": "utf-8"])
    public static let json = MediaType(type: "application", subType: "json", parameters: ["charset": "utf-8"])
    public static let jsonAPI = MediaType(type: "application", subType: "vnd.api+json", parameters: ["charset": "utf-8"])
}
