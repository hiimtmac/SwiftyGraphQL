// MediaType.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct MediaType: Hashable {
    public let type: String
    public let subType: String
    public let parameters: [String: String]

    public init(type: String, subType: String, parameters: [String: String] = [:]) {
        self.type = type
        self.subType = subType
        self.parameters = parameters
    }

    public func serialize() -> String {
        var string = "\(type)/\(subType)"
        for (key, val) in self.parameters {
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
