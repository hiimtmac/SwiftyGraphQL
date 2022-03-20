// HTTPHeaderName.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct HTTPHeaderName: Hashable {
    public let name: String

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
